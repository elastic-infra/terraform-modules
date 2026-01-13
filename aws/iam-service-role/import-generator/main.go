package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"github.com/hashicorp/hcl/v2/hclparse"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/zclconf/go-cty/cty"
)

const (
	resourceTypeAttachments = "aws_iam_role_policy_attachments_exclusive"
	resourceTypePolicies    = "aws_iam_role_policies_exclusive"
	resourceName            = "this"
	modulePrefix            = "module."
	iamRoleType             = "aws_iam_role"

	forEachKeyStartMarker = "[\""
	forEachKeyEndMarker   = "\"]"
)

type ModuleInfo struct {
	Name          string
	Source        string
	NameExpr      string
	ForEach       string
	Count         string
	ModulePath    []string
	ParentForEach string
	ParentCount   string
}

type TerraformState struct {
	Values struct {
		RootModule struct {
			ChildModules []Module `json:"child_modules"`
		} `json:"root_module"`
	} `json:"values"`
}

type Module struct {
	Address      string     `json:"address"`
	Resources    []Resource `json:"resources"`
	ChildModules []Module   `json:"child_modules"`
}

type Resource struct {
	Address string                 `json:"address"`
	Type    string                 `json:"type"`
	Name    string                 `json:"name"`
	Values  map[string]interface{} `json:"values"`
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	parser := hclparse.NewParser()

	modules, err := scanDirectory(".", []string{}, "", "", parser)
	if err != nil {
		return err
	}

	if len(modules) == 0 {
		fmt.Fprintf(os.Stderr, "No target modules found\n")
		return nil
	}

	state, err := getTerraformState()
	if err != nil {
		return fmt.Errorf("failed to get terraform state: %w", err)
	}

	for _, mod := range modules {
		if err := generateImportBlockWithState(mod, state); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to generate import block for %s: %v\n",
				strings.Join(mod.ModulePath, "."), err)
		}
	}

	return nil
}

func getTerraformState() (*TerraformState, error) {
	cmd := exec.Command("terraform", "show", "-json")
	output, err := cmd.Output()
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			return nil, fmt.Errorf("terraform show failed: %s", string(exitErr.Stderr))
		}
		return nil, err
	}

	var state TerraformState
	if err := json.Unmarshal(output, &state); err != nil {
		return nil, fmt.Errorf("failed to parse terraform state JSON: %w", err)
	}

	return &state, nil
}

func scanDirectory(dir string, modulePath []string, parentForEach, parentCount string, parser *hclparse.Parser) ([]ModuleInfo, error) {
	var allModules []ModuleInfo

	pattern := filepath.Join(dir, "*.tf")
	files, err := filepath.Glob(pattern)
	if err != nil {
		return nil, fmt.Errorf("failed to glob files in %s: %w", dir, err)
	}

	for _, file := range files {
		content, err := os.ReadFile(file)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Warning: failed to read file %s: %v\n", file, err)
			continue
		}

		f, diags := parser.ParseHCL(content, file)
		if diags.HasErrors() {
			fmt.Fprintf(os.Stderr, "Warning: failed to parse %s: %s\n", file, diags.Error())
			continue
		}

		body, ok := f.Body.(*hclsyntax.Body)
		if !ok {
			continue
		}

		modules := extractModules(body, content, modulePath, parentForEach, parentCount, dir, parser)
		allModules = append(allModules, modules...)
	}

	return allModules, nil
}

func extractModules(body *hclsyntax.Body, src []byte, parentModulePath []string, parentForEach, parentCount, currentDir string, parser *hclparse.Parser) []ModuleInfo {
	var modules []ModuleInfo

	for _, block := range body.Blocks {
		if block.Type == "module" && len(block.Labels) > 0 {
			moduleName := block.Labels[0]
			moduleBody := block.Body

			var source string
			if attr, exists := moduleBody.Attributes["source"]; exists {
				sourceVal, diags := attr.Expr.Value(nil)
				if !diags.HasErrors() && sourceVal.Type() == cty.String {
					source = sourceVal.AsString()
				}
			}

			if isLocalModule(source) {
				localPath := filepath.Join(currentDir, source)
				newModulePath := append(parentModulePath, moduleName)

				var forEachExpr, countExpr string
				if attr, exists := moduleBody.Attributes["for_each"]; exists {
					forEachExpr = string(attr.Expr.Range().SliceBytes(src))
				}
				if attr, exists := moduleBody.Attributes["count"]; exists {
					countExpr = string(attr.Expr.Range().SliceBytes(src))
				}

				subModules, err := scanDirectory(localPath, newModulePath, forEachExpr, countExpr, parser)
				if err != nil {
					fmt.Fprintf(os.Stderr, "Warning: failed to scan local module %s: %v\n", localPath, err)
				} else {
					modules = append(modules, subModules...)
				}
			}

			if strings.Contains(source, "github.com/elastic-infra/terraform-modules//aws/iam-service-role") {
				mod := analyzeModuleBlock(moduleName, block, src, parentModulePath, parentForEach, parentCount)
				if mod != nil {
					modules = append(modules, *mod)
				}
			}
		}
	}

	return modules
}

func isLocalModule(source string) bool {
	return strings.HasPrefix(source, "./") ||
		strings.HasPrefix(source, "../")
}

func analyzeModuleBlock(moduleName string, block *hclsyntax.Block, src []byte, parentModulePath []string, parentForEach, parentCount string) *ModuleInfo {
	var source, nameExpr, forEachExpr, countExpr string

	body := block.Body

	if attr, exists := body.Attributes["source"]; exists {
		sourceVal, diags := attr.Expr.Value(nil)
		if !diags.HasErrors() && sourceVal.Type() == cty.String {
			source = sourceVal.AsString()
		}
	}

	if attr, exists := body.Attributes["name"]; exists {
		nameExpr = string(attr.Expr.Range().SliceBytes(src))
	}

	if attr, exists := body.Attributes["for_each"]; exists {
		forEachExpr = string(attr.Expr.Range().SliceBytes(src))
	}

	if attr, exists := body.Attributes["count"]; exists {
		countExpr = string(attr.Expr.Range().SliceBytes(src))
	}

	modulePath := append(parentModulePath, moduleName)

	return &ModuleInfo{
		Name:          moduleName,
		Source:        source,
		NameExpr:      nameExpr,
		ForEach:       forEachExpr,
		Count:         countExpr,
		ModulePath:    modulePath,
		ParentForEach: parentForEach,
		ParentCount:   parentCount,
	}
}

func buildModulePath(modulePath []string) string {
	var pathParts []string
	for _, name := range modulePath {
		pathParts = append(pathParts, modulePrefix+name)
	}
	return strings.Join(pathParts, ".")
}

func generateImportBlockWithState(mod ModuleInfo, state *TerraformState) error {
	basePath := buildModulePath(mod.ModulePath)

	if mod.ParentForEach != "" {
		parentPath := buildModulePath(mod.ModulePath[:len(mod.ModulePath)-1])

		keys, err := extractForEachKeys(state, parentPath)
		if err != nil {
			return err
		}

		if len(keys) == 0 {
			return fmt.Errorf("no instances found in state for parent for_each module")
		}

		fmt.Printf("import {\n")
		fmt.Printf("  for_each = %s\n\n", mod.ParentForEach)
		fmt.Printf("  to = %s[each.key].module.%s.aws_iam_role_policy_attachments_exclusive.this\n", parentPath, mod.Name)
		fmt.Printf("  id = {\n")
		for _, key := range keys {
			fullPath := fmt.Sprintf("%s[\"%s\"].module.%s", parentPath, key, mod.Name)
			roleName, err := getRoleNameFromState(state, fullPath, "", -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s: %v\n", fullPath, err)
				continue
			}
			fmt.Printf("    %s = %q\n", key, roleName)
		}
		fmt.Printf("  }[each.key]\n")
		fmt.Printf("}\n\n")

		fmt.Printf("import {\n")
		fmt.Printf("  for_each = %s\n\n", mod.ParentForEach)
		fmt.Printf("  to = %s[each.key].module.%s.aws_iam_role_policies_exclusive.this\n", parentPath, mod.Name)
		fmt.Printf("  id = {\n")
		for _, key := range keys {
			fullPath := fmt.Sprintf("%s[\"%s\"].module.%s", parentPath, key, mod.Name)
			roleName, err := getRoleNameFromState(state, fullPath, "", -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s: %v\n", fullPath, err)
				continue
			}
			fmt.Printf("    %s = %q\n", key, roleName)
		}
		fmt.Printf("  }[each.key]\n")
		fmt.Printf("}\n\n")

		return nil
	}

	if mod.ParentCount != "" {
		parentPath := buildModulePath(mod.ModulePath[:len(mod.ModulePath)-1])

		count, err := extractCountValue(state, parentPath)
		if err != nil {
			return err
		}

		if count == 0 {
			return fmt.Errorf("no instances found in state for parent count module")
		}

		fmt.Printf("import {\n")
		fmt.Printf("  count = %s\n\n", mod.ParentCount)
		fmt.Printf("  to = %s[count.index].module.%s.aws_iam_role_policy_attachments_exclusive.this\n", parentPath, mod.Name)
		fmt.Printf("  id = [\n")
		for i := 0; i < count; i++ {
			fullPath := fmt.Sprintf("%s[%d].module.%s", parentPath, i, mod.Name)
			roleName, err := getRoleNameFromState(state, fullPath, "", -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s: %v\n", fullPath, err)
				continue
			}
			fmt.Printf("    %q,\n", roleName)
		}
		fmt.Printf("  ][count.index]\n")
		fmt.Printf("}\n\n")

		fmt.Printf("import {\n")
		fmt.Printf("  count = %s\n\n", mod.ParentCount)
		fmt.Printf("  to = %s[count.index].module.%s.aws_iam_role_policies_exclusive.this\n", parentPath, mod.Name)
		fmt.Printf("  id = [\n")
		for i := 0; i < count; i++ {
			fullPath := fmt.Sprintf("%s[%d].module.%s", parentPath, i, mod.Name)
			roleName, err := getRoleNameFromState(state, fullPath, "", -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s: %v\n", fullPath, err)
				continue
			}
			fmt.Printf("    %q,\n", roleName)
		}
		fmt.Printf("  ][count.index]\n")
		fmt.Printf("}\n\n")

		return nil
	}

	modulePathPrefix := basePath

	if mod.ForEach != "" {
		keys, err := extractForEachKeys(state, modulePathPrefix)
		if err != nil {
			return err
		}

		if len(keys) == 0 {
			return fmt.Errorf("no instances found in state for for_each module")
		}

		fmt.Printf("import {\n")
		fmt.Printf("  for_each = %s\n\n", mod.ForEach)
		fmt.Printf("  to = %s[each.key].aws_iam_role_policy_attachments_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = {\n")
		for _, key := range keys {
			roleName, err := getRoleNameFromState(state, modulePathPrefix, key, -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s[%s]: %v\n", modulePathPrefix, key, err)
				continue
			}
			fmt.Printf("    %s = %q\n", key, roleName)
		}
		fmt.Printf("  }[each.key]\n")
		fmt.Printf("}\n\n")
		fmt.Printf("import {\n")
		fmt.Printf("  for_each = %s\n\n", mod.ForEach)
		fmt.Printf("  to = %s[each.key].aws_iam_role_policies_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = {\n")
		for _, key := range keys {
			roleName, err := getRoleNameFromState(state, modulePathPrefix, key, -1)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s[%s]: %v\n", modulePathPrefix, key, err)
				continue
			}
			fmt.Printf("    %s = %q\n", key, roleName)
		}
		fmt.Printf("  }[each.key]\n")
		fmt.Printf("}\n\n")

	} else if mod.Count != "" {
		count, err := extractCountValue(state, modulePathPrefix)
		if err != nil {
			return err
		}

		if count == 0 {
			return fmt.Errorf("no instances found in state for count module")
		}

		fmt.Printf("import {\n")
		fmt.Printf("  count = %s\n\n", mod.Count)
		fmt.Printf("  to = %s[count.index].aws_iam_role_policy_attachments_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = [\n")
		for i := 0; i < count; i++ {
			roleName, err := getRoleNameFromState(state, modulePathPrefix, "", i)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s[%d]: %v\n", modulePathPrefix, i, err)
				continue
			}
			fmt.Printf("    %q,\n", roleName)
		}
		fmt.Printf("  ][count.index]\n")
		fmt.Printf("}\n\n")
		fmt.Printf("import {\n")
		fmt.Printf("  count = %s\n\n", mod.Count)
		fmt.Printf("  to = %s[count.index].aws_iam_role_policies_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = [\n")
		for i := 0; i < count; i++ {
			roleName, err := getRoleNameFromState(state, modulePathPrefix, "", i)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Warning: failed to get role name for %s[%d]: %v\n", modulePathPrefix, i, err)
				continue
			}
			fmt.Printf("    %q,\n", roleName)
		}
		fmt.Printf("  ][count.index]\n")
		fmt.Printf("}\n\n")

	} else {
		roleName, err := getRoleNameFromState(state, modulePathPrefix, "", -1)
		if err != nil {
			return err
		}

		fmt.Printf("import {\n")
		fmt.Printf("  to = %s.aws_iam_role_policy_attachments_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = %q\n", roleName)
		fmt.Printf("}\n\n")
		fmt.Printf("import {\n")
		fmt.Printf("  to = %s.aws_iam_role_policies_exclusive.this\n", modulePathPrefix)
		fmt.Printf("  id = %q\n", roleName)
		fmt.Printf("}\n\n")
	}

	return nil
}

func extractForEachKeys(state *TerraformState, modulePathPrefix string) ([]string, error) {
	keyMap := make(map[string]bool)
	modules := findModules(state.Values.RootModule.ChildModules, modulePathPrefix)

	for _, mod := range modules {
		if strings.Contains(mod.Address, "[") {
			start := strings.Index(mod.Address, "[\"")
			end := strings.Index(mod.Address, "\"]")
			if start != -1 && end != -1 {
				key := mod.Address[start+2 : end]
				keyMap[key] = true
			}
		}
	}

	var keys []string
	for key := range keyMap {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	return keys, nil
}

func extractCountValue(state *TerraformState, modulePathPrefix string) (int, error) {
	modules := findModules(state.Values.RootModule.ChildModules, modulePathPrefix)
	return len(modules), nil
}

func getRoleNameFromState(state *TerraformState, modulePathPrefix, forEachKey string, countIndex int) (string, error) {
	var targetAddress string

	if forEachKey != "" {
		targetAddress = fmt.Sprintf("%s[\"%s\"]", modulePathPrefix, forEachKey)
	} else if countIndex >= 0 {
		targetAddress = fmt.Sprintf("%s[%d]", modulePathPrefix, countIndex)
	} else {
		targetAddress = modulePathPrefix
	}

	modules := findModules(state.Values.RootModule.ChildModules, targetAddress)
	if len(modules) == 0 {
		return "", fmt.Errorf("module not found in state: %s", targetAddress)
	}

	for _, resource := range modules[0].Resources {
		if resource.Type == "aws_iam_role" && resource.Name == "this" {
			if name, ok := resource.Values["name"].(string); ok {
				return name, nil
			}
			return "", fmt.Errorf("name attribute not found in aws_iam_role")
		}
	}

	return "", fmt.Errorf("aws_iam_role.this not found in module %s", targetAddress)
}

func findModules(modules []Module, targetAddress string) []Module {
	var result []Module

	for _, mod := range modules {
		if mod.Address == targetAddress {
			result = append(result, mod)
		}
		if strings.HasPrefix(mod.Address, targetAddress+"[") {
			result = append(result, mod)
		}

		if len(mod.ChildModules) > 0 {
			result = append(result, findModules(mod.ChildModules, targetAddress)...)
		}
	}

	return result
}
