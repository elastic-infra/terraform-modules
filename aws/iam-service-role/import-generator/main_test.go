package main

import (
	"bytes"
	"io"
	"os"
	"reflect"
	"strings"
	"testing"
)

func createTestState(modules []Module) *TerraformState {
	state := &TerraformState{}
	state.Values.RootModule.ChildModules = modules
	return state
}

func captureOutput(f func()) string {
	old := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	f()

	w.Close()
	os.Stdout = old

	var buf bytes.Buffer
	io.Copy(&buf, r)
	return buf.String()
}

func TestIsLocalModule(t *testing.T) {
	tests := []struct {
		name     string
		source   string
		expected bool
	}{
		{"relative path ./", "./module", true},
		{"relative path ../", "../module", true},
		{"relative path ../../", "../../module/path", true},
		{"GitHub URL", "github.com/org/repo//path", false},
		{"GitHub URL with https", "https://github.com/org/repo", false},
		{"Registry module", "hashicorp/consul/aws", false},
		{"Registry module with version", "hashicorp/consul/aws?version=1.0.0", false},
		{"S3 source", "s3::https://bucket.s3.amazonaws.com/module.zip", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := isLocalModule(tt.source)
			if result != tt.expected {
				t.Errorf("isLocalModule(%q) = %v, want %v", tt.source, result, tt.expected)
			}
		})
	}
}

func TestFindModules(t *testing.T) {
	tests := []struct {
		name          string
		modules       []Module
		targetAddress string
		expectedCount int
	}{
		{
			name: "exact match",
			modules: []Module{
				{Address: "module.x"},
			},
			targetAddress: "module.x",
			expectedCount: 1,
		},
		{
			name: "prefix match with for_each key",
			modules: []Module{
				{Address: "module.x[\"prod\"]"},
				{Address: "module.x[\"dev\"]"},
			},
			targetAddress: "module.x",
			expectedCount: 2,
		},
		{
			name: "nested module",
			modules: []Module{
				{
					Address: "module.parent",
					ChildModules: []Module{
						{Address: "module.parent.module.child"},
					},
				},
			},
			targetAddress: "module.parent.module.child",
			expectedCount: 1,
		},
		{
			name: "not found",
			modules: []Module{
				{Address: "module.x"},
			},
			targetAddress: "module.y",
			expectedCount: 0,
		},
		{
			name: "deeply nested module",
			modules: []Module{
				{
					Address: "module.level1",
					ChildModules: []Module{
						{
							Address: "module.level1.module.level2",
							ChildModules: []Module{
								{Address: "module.level1.module.level2.module.level3"},
							},
						},
					},
				},
			},
			targetAddress: "module.level1.module.level2.module.level3",
			expectedCount: 1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := findModules(tt.modules, tt.targetAddress)
			if len(result) != tt.expectedCount {
				t.Errorf("findModules() returned %d modules, want %d", len(result), tt.expectedCount)
			}
		})
	}
}

func TestExtractForEachKeys(t *testing.T) {
	tests := []struct {
		name         string
		modules      []Module
		modulePrefix string
		expected     []string
	}{
		{
			name: "single key",
			modules: []Module{
				{Address: "module.x[\"prod\"]"},
			},
			modulePrefix: "module.x",
			expected:     []string{"prod"},
		},
		{
			name: "multiple keys sorted",
			modules: []Module{
				{Address: "module.x[\"prod\"]"},
				{Address: "module.x[\"dev\"]"},
				{Address: "module.x[\"staging\"]"},
			},
			modulePrefix: "module.x",
			expected:     []string{"dev", "prod", "staging"},
		},
		{
			name: "duplicate keys removed",
			modules: []Module{
				{Address: "module.x[\"prod\"]"},
				{
					Address: "module.x[\"prod\"]",
					ChildModules: []Module{
						{Address: "module.x[\"prod\"].module.child"},
					},
				},
			},
			modulePrefix: "module.x",
			expected:     []string{"prod"},
		},
		{
			name: "no for_each",
			modules: []Module{
				{Address: "module.x"},
			},
			modulePrefix: "module.x",
			expected:     []string{},
		},
		{
			name: "key with special characters",
			modules: []Module{
				{Address: "module.x[\"my-key\"]"},
				{Address: "module.x[\"my_key\"]"},
			},
			modulePrefix: "module.x",
			expected:     []string{"my-key", "my_key"},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			state := createTestState(tt.modules)
			result, err := extractForEachKeys(state, tt.modulePrefix)
			if err != nil {
				t.Errorf("extractForEachKeys() error = %v", err)
				return
			}
			if len(result) == 0 && len(tt.expected) == 0 {
				return
			}
			if !reflect.DeepEqual(result, tt.expected) {
				t.Errorf("extractForEachKeys() = %v, want %v", result, tt.expected)
			}
		})
	}
}

func TestExtractCountValue(t *testing.T) {
	tests := []struct {
		name         string
		modules      []Module
		modulePrefix string
		expected     int
	}{
		{
			name: "count=3",
			modules: []Module{
				{Address: "module.x[0]"},
				{Address: "module.x[1]"},
				{Address: "module.x[2]"},
			},
			modulePrefix: "module.x",
			expected:     3,
		},
		{
			name:         "count=0",
			modules:      []Module{},
			modulePrefix: "module.x",
			expected:     0,
		},
		{
			name: "count=1",
			modules: []Module{
				{Address: "module.x[0]"},
			},
			modulePrefix: "module.x",
			expected:     1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			state := createTestState(tt.modules)
			result, err := extractCountValue(state, tt.modulePrefix)
			if err != nil {
				t.Errorf("extractCountValue() error = %v", err)
				return
			}
			if result != tt.expected {
				t.Errorf("extractCountValue() = %d, want %d", result, tt.expected)
			}
		})
	}
}

func TestGetRoleNameFromState(t *testing.T) {
	tests := []struct {
		name         string
		modules      []Module
		modulePrefix string
		forEachKey   string
		countIndex   int
		expected     string
		expectError  bool
	}{
		{
			name: "normal retrieval",
			modules: []Module{
				{
					Address: "module.role",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "my-role"}},
					},
				},
			},
			modulePrefix: "module.role",
			forEachKey:   "",
			countIndex:   -1,
			expected:     "my-role",
			expectError:  false,
		},
		{
			name: "with for_each key",
			modules: []Module{
				{
					Address: "module.role[\"prod\"]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "prod-role"}},
					},
				},
			},
			modulePrefix: "module.role",
			forEachKey:   "prod",
			countIndex:   -1,
			expected:     "prod-role",
			expectError:  false,
		},
		{
			name: "with count index",
			modules: []Module{
				{
					Address: "module.role[0]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "role-0"}},
					},
				},
			},
			modulePrefix: "module.role",
			forEachKey:   "",
			countIndex:   0,
			expected:     "role-0",
			expectError:  false,
		},
		{
			name:         "module not found",
			modules:      []Module{},
			modulePrefix: "module.nonexistent",
			forEachKey:   "",
			countIndex:   -1,
			expected:     "",
			expectError:  true,
		},
		{
			name: "role resource not found",
			modules: []Module{
				{
					Address: "module.role",
					Resources: []Resource{
						{Type: "aws_iam_policy", Name: "this", Values: map[string]interface{}{"name": "my-policy"}},
					},
				},
			},
			modulePrefix: "module.role",
			forEachKey:   "",
			countIndex:   -1,
			expected:     "",
			expectError:  true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			state := createTestState(tt.modules)
			result, err := getRoleNameFromState(state, tt.modulePrefix, tt.forEachKey, tt.countIndex)
			if tt.expectError {
				if err == nil {
					t.Errorf("getRoleNameFromState() expected error, got nil")
				}
				return
			}
			if err != nil {
				t.Errorf("getRoleNameFromState() error = %v", err)
				return
			}
			if result != tt.expected {
				t.Errorf("getRoleNameFromState() = %q, want %q", result, tt.expected)
			}
		})
	}
}

func TestGenerateImportBlockWithState(t *testing.T) {
	tests := []struct {
		name              string
		mod               ModuleInfo
		modules           []Module
		expectedToContain []string
	}{
		{
			name: "root module no iteration",
			mod: ModuleInfo{
				Name:       "role",
				ModulePath: []string{"role"},
			},
			modules: []Module{
				{
					Address: "module.role",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "my-role"}},
					},
				},
			},
			expectedToContain: []string{
				"to = module.role.aws_iam_role_policy_attachments_exclusive.this",
				"id = \"my-role\"",
			},
		},
		{
			name: "root module with for_each",
			mod: ModuleInfo{
				Name:       "role",
				ModulePath: []string{"role"},
				ForEach:    "var.roles",
			},
			modules: []Module{
				{
					Address: "module.role[\"admin\"]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "admin-role"}},
					},
				},
				{
					Address: "module.role[\"user\"]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "user-role"}},
					},
				},
			},
			expectedToContain: []string{
				"for_each = var.roles",
				"to = module.role[each.key].aws_iam_role_policy_attachments_exclusive.this",
				"admin = \"admin-role\"",
				"user = \"user-role\"",
			},
		},
		{
			name: "root module with count",
			mod: ModuleInfo{
				Name:       "role",
				ModulePath: []string{"role"},
				Count:      "var.role_count",
			},
			modules: []Module{
				{
					Address: "module.role[0]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "role-0"}},
					},
				},
				{
					Address: "module.role[1]",
					Resources: []Resource{
						{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "role-1"}},
					},
				},
			},
			expectedToContain: []string{
				"count = var.role_count",
				"to = module.role[count.index].aws_iam_role_policy_attachments_exclusive.this",
				"\"role-0\"",
				"\"role-1\"",
			},
		},
		{
			name: "child module no parent iteration no self iteration",
			mod: ModuleInfo{
				Name:       "child",
				ModulePath: []string{"parent", "child"},
			},
			modules: []Module{
				{
					Address: "module.parent",
					ChildModules: []Module{
						{
							Address: "module.parent.module.child",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "child-role"}},
							},
						},
					},
				},
			},
			expectedToContain: []string{
				"to = module.parent.module.child.aws_iam_role_policy_attachments_exclusive.this",
				"id = \"child-role\"",
			},
		},
		{
			name: "child module no parent iteration self for_each",
			mod: ModuleInfo{
				Name:       "child",
				ModulePath: []string{"parent", "child"},
				ForEach:    "var.envs",
			},
			modules: []Module{
				{
					Address: "module.parent",
					ChildModules: []Module{
						{
							Address: "module.parent.module.child[\"prod\"]",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "prod-child-role"}},
							},
						},
					},
				},
			},
			expectedToContain: []string{
				"for_each = var.envs",
				"to = module.parent.module.child[each.key].aws_iam_role_policy_attachments_exclusive.this",
				"prod = \"prod-child-role\"",
			},
		},
		{
			name: "child module no parent iteration self count",
			mod: ModuleInfo{
				Name:       "child",
				ModulePath: []string{"parent", "child"},
				Count:      "var.child_count",
			},
			modules: []Module{
				{
					Address: "module.parent",
					ChildModules: []Module{
						{
							Address: "module.parent.module.child[0]",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "child-role-0"}},
							},
						},
					},
				},
			},
			expectedToContain: []string{
				"count = var.child_count",
				"to = module.parent.module.child[count.index].aws_iam_role_policy_attachments_exclusive.this",
				"\"child-role-0\"",
			},
		},
		{
			name: "child module parent for_each",
			mod: ModuleInfo{
				Name:          "child",
				ModulePath:    []string{"parent", "child"},
				ParentForEach: "local.envs",
			},
			modules: []Module{
				{
					Address: "module.parent[\"prod\"]",
					ChildModules: []Module{
						{
							Address: "module.parent[\"prod\"].module.child",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "prod-child-role"}},
							},
						},
					},
				},
				{
					Address: "module.parent[\"dev\"]",
					ChildModules: []Module{
						{
							Address: "module.parent[\"dev\"].module.child",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "dev-child-role"}},
							},
						},
					},
				},
			},
			expectedToContain: []string{
				"for_each = local.envs",
				"to = module.parent[each.key].module.child.aws_iam_role_policy_attachments_exclusive.this",
				"dev = \"dev-child-role\"",
				"prod = \"prod-child-role\"",
			},
		},
		{
			name: "child module parent count",
			mod: ModuleInfo{
				Name:        "child",
				ModulePath:  []string{"parent", "child"},
				ParentCount: "var.parent_count",
			},
			modules: []Module{
				{
					Address: "module.parent[0]",
					ChildModules: []Module{
						{
							Address: "module.parent[0].module.child",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "child-role-0"}},
							},
						},
					},
				},
				{
					Address: "module.parent[1]",
					ChildModules: []Module{
						{
							Address: "module.parent[1].module.child",
							Resources: []Resource{
								{Type: "aws_iam_role", Name: "this", Values: map[string]interface{}{"name": "child-role-1"}},
							},
						},
					},
				},
			},
			expectedToContain: []string{
				"count = var.parent_count",
				"to = module.parent[count.index].module.child.aws_iam_role_policy_attachments_exclusive.this",
				"\"child-role-0\"",
				"\"child-role-1\"",
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			state := createTestState(tt.modules)
			output := captureOutput(func() {
				err := generateImportBlockWithState(tt.mod, state)
				if err != nil {
					t.Errorf("generateImportBlockWithState() error = %v", err)
				}
			})

			for _, expected := range tt.expectedToContain {
				if !strings.Contains(output, expected) {
					t.Errorf("output does not contain %q\nGot:\n%s", expected, output)
				}
			}
		})
	}
}

func TestGenerateImportBlockWithStateErrors(t *testing.T) {
	tests := []struct {
		name    string
		mod     ModuleInfo
		modules []Module
	}{
		{
			name: "parent for_each no keys found",
			mod: ModuleInfo{
				Name:          "child",
				ModulePath:    []string{"parent", "child"},
				ParentForEach: "local.envs",
			},
			modules: []Module{},
		},
		{
			name: "parent count zero instances",
			mod: ModuleInfo{
				Name:        "child",
				ModulePath:  []string{"parent", "child"},
				ParentCount: "var.count",
			},
			modules: []Module{},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			state := createTestState(tt.modules)
			_ = captureOutput(func() {
				err := generateImportBlockWithState(tt.mod, state)
				if err == nil {
					t.Errorf("generateImportBlockWithState() expected error, got nil")
				}
			})
		})
	}
}
