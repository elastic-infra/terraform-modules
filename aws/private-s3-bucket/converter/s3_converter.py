#!/usr/bin/env python3.9

import sys
import json
import logging
import argparse


class S3StateConverter:
    def __init__(self, argv):
        """引数処理する

        $ $0 list < foo.tfstate
        $ $0 list foo.tfstate

        $ $0 convert SOURCE_NAME DESTINATION_NAME < foo.tfstate
        $ $0 convert SOURCE_NAME DESTINATION_NAME foo.tfstate
        として実行したとき
        SOURCE_NAME: state中のリソース名
        DESTINATION_NAME: importされる新リソース名
        """
        parser = argparse.ArgumentParser(prog=argv[0])
        parser.add_argument("--debug", action="store_true")
        parser.add_argument("-f", "--tfstate", type=str, default="/dev/stdin")
        subparsers = parser.add_subparsers(
            dest="subparser_name", help="sub-command help"
        )
        parser_list = subparsers.add_parser("list", help="list help")
        parser_convert = subparsers.add_parser("convert-v4", help="convert-v4 help")
        parser_convert.add_argument("resource_name", type=str, nargs="?")
        args = parser.parse_args(argv[1:])
        self.tfstate_file = open(args.tfstate)
        self.mode = args.subparser_name
        if args.subparser_name == "convert-v4":
            self.resource_name = args.resource_name
        if args.debug:
            logging.basicConfig(level="DEBUG")

    def main(self):
        self.load_tfstate()
        if self.mode == "list":
            for b in self.iter_s3_buckets():
                print(self.printable_resource_name(b))
        if self.mode == "convert-v4":
            resources = []
            outputs = []
            if self.resource_name:
                resources.append(self.resource_name)
            else:
                resources = [
                    self.printable_resource_name(b) for b in self.iter_s3_buckets()
                ]
            for b in resources:
                logging.debug("Trying to find %s", b)
                source = self.find_resource(b)
                logging.debug(source)
                results = self.convert_resource(source)
                outputs.extend([r for r in results if r])
            logging.debug(outputs)
            cmds = [o[0] for o in outputs]
            hcls = [o[1] for o in outputs]
            print("# Commands")
            for cmd in cmds:
                print(cmd)
            print("\n# Sample HCLs")
            for hcl in hcls:
                print(hcl)

    def load_tfstate(self):
        logging.debug("BEGIN Loading tfstate")
        self.tfstate = json.load(self.tfstate_file)
        logging.debug("END Loading tfstate")

    def iter_s3_buckets(self):
        for resource in self.tfstate["resources"]:
            if self.is_s3_resource(resource):
                yield resource

    def find_resource(self, name):
        for resource in self.tfstate["resources"]:
            if self.is_matched(resource, name):
                logging.debug("Found source")
                return resource

    def printable_resource_name(self, resource):
        return ".".join(
            filter(None, [resource.get("module"), resource["type"], resource["name"]])
        )

    def is_s3_resource(self, resource):
        if resource["mode"] != "managed":
            return False
        return resource["type"] == "aws_s3_bucket"

    def is_matched(self, resource, name):
        if not self.is_s3_resource(resource):
            return False
        # correct judge even for nested module
        resource_name = self.printable_resource_name(resource)
        return resource_name == name

    def convert_resource(self, resource):
        """Import command and the sample terraform HCL.

        Effective only if the necessary attributes are set on to the resource.
        """
        return [
            self.convert_resource_versioning(resource),
            self.convert_resource_logging(resource),
            self.convert_resource_sse(resource),
            self.convert_resource_cors(resource),
            self.convert_resource_object_lock(resource),
            self.convert_resource_acl(resource),
            self.convert_resource_lifecycle(resource),
        ]

    def convert_resource_versioning(self, resource):
        instance = resource["instances"][0]
        attr = instance["attributes"]["versioning"]
        bucket = instance["attributes"]["bucket"]
        logging.debug(attr)
        if attr[0]["enabled"] == False:
            logging.debug("Versioning is not enabled for bucket %s", bucket)
            return
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_versioning.{resource['name']} {bucket}"
        hcl = f"""#{module_line}resource "aws_s3_bucket_versioning" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id
  versioning_configuration {{
    status     = {'"Enabled"' if attr[0]["enabled"] else '"Suspended"'}
    mfa_delete = {'"Enabled"' if attr[0]["mfa_delete"] else '"Disabled"'}
  }}
}}
        """
        return [import_cmd, hcl]

    def convert_resource_logging(self, resource):
        instance = resource["instances"][0]
        attr = instance["attributes"]["logging"]
        bucket = instance["attributes"]["bucket"]
        if len(attr) == 0:
            logging.debug("Logging is not enabled for bucket %s", bucket)
            return
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_logging.{resource['name']} {bucket}"
        hcl = f"""#{module_line}resource "aws_s3_bucket_logging" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id

  target_bucket = "{attr[0]["target_bucket"]}"
  target_prefix = "{attr[0]["target_prefix"]}"
}}
        """
        return [import_cmd, hcl]

    def convert_resource_sse(self, resource):
        instance = resource["instances"][0]
        attr = instance["attributes"]["server_side_encryption_configuration"]
        bucket = instance["attributes"]["bucket"]
        if len(attr) == 0:
            logging.debug("SSE is not enabled for bucket %s", bucket)
            return
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_server_side_encryption_configuration.{resource['name']} {bucket}"
        hcl = f"""#{module_line}resource "aws_s3_bucket_server_side_encryption_configuration" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id

  rule {{
    apply_server_side_encryption_by_default {{
      kms_master_key_id = "{attr[0]["rule"][0]["apply_server_side_encryption_by_default"][0]["kms_master_key_id"]}"
      sse_algorithm     = "{attr[0]["rule"][0]["apply_server_side_encryption_by_default"][0]["sse_algorithm"]}"
    }}
  }}
}}
        """
        return [import_cmd, hcl]

    def convert_resource_cors(self, resource):
        instance = resource["instances"][0]
        attr = instance["attributes"]["cors_rule"]
        bucket = instance["attributes"]["bucket"]
        if len(attr) == 0:
            logging.debug("CORS is not enabled for bucket %s", bucket)
            return
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_cors_configuration.{resource['name']} {bucket}"
        cors_rules = "\n".join([
            f"""  cors_rule {{
    allowed_headers = {json.dumps(attr[i]["allowed_headers"])}
    allowed_methods = {json.dumps(attr[i]["allowed_methods"])}
    allowed_origins = {json.dumps(attr[i]["allowed_origins"])}
    expose_headers  = {json.dumps(attr[i]["expose_headers"])}
    max_age_seconds = {attr[i]["max_age_seconds"] if "max_age_seconds" in attr[i] else None}
  }}"""
            for i in range(len(attr))
        ])
        hcl = f"""#{module_line}resource "aws_s3_bucket_cors_configuration" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id

{cors_rules}
}}"""
        return [import_cmd, hcl]

    def convert_resource_object_lock(self, resource):
        instance = resource["instances"][0]
        attr = instance["attributes"]["object_lock_configuration"]
        bucket = instance["attributes"]["bucket"]
        if len(attr) == 0:
            logging.debug("Object Lock is not enabled for bucket %s", bucket)
            return
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_object_lock_configuration.{resource['name']} {bucket}"
        hcl = f"""#{module_line}resource "aws_s3_bucket_object_lock_configuration" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id

  rule {{
    default_retention {{
      mode  = "{attr[0]["rule"][0]["default_retention"][0]["mode"]}"
      days  = "{attr[0]["rule"][0]["default_retention"][0]["days"]}"
      years = "{attr[0]["rule"][0]["default_retention"][0]["years"]}"
    }}
  }}
}}
        """
        return [import_cmd, hcl]

    def __grant_config(self, grant_attr):
        for grant in grant_attr:
            for permission in grant["permissions"]:
                yield [grant, permission]

    def convert_resource_acl(self, resource):
        instance = resource["instances"][0]
        acl_attr = instance["attributes"]["acl"]
        grant_attr = instance["attributes"]["grant"]
        bucket = instance["attributes"]["bucket"]
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        acl_hcl = ""
        acp_hcl = ""
        if len(grant_attr) == 0:
            acl_hcl = f'  acl = "{acl_attr}"'
        else:
            grants_acl = "\n".join([
                f"""    grant {{
      grantee {{
        id   = "{g[0]["id"]}"
        type = "{g[0]["type"]}"
        uri  = "{g[0]["uri"]}"
      }}
      permission = "{g[1]}"
    }}"""
            for g in self.__grant_config(grant_attr)])
            acp_hcl  = f"""  access_control_policy {{
{grants_acl}
  }}"""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_acl.{resource['name']} {bucket}"
        hcl = f"""#{module_line}resource "aws_s3_bucket_acl" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id

{acl_hcl}{acp_hcl}
}}
"""
        return [import_cmd, hcl]

    def _lifecycle_rule_filter(self, rule):
        if rule["prefix"] == "" and rule["tags"] == {}:
            return ""
        filter = "    filter {\n"
        if rule["prefix"] != "":
            filter += f'''      prefix = "{rule["prefix"]}"\n'''
        if rule["tags"] != {}:
            filter += f"""      tags {{
        key   = "{rule["tags"]["key"]}"
        value = "{rule["tags"]["value"]}"
      }}
"""
        filter += "    }\n"
        return filter

    def _lifecycle_rule_abort_multipart_incomplete_multipart_upload(self, rule):
        if rule["abort_incomplete_multipart_upload_days"] > 0:
            return f'    abort_incomplete_multipart_upload = {rule["abort_incomplete_multipart_upload_days"]}'
        return ""

    def _lifecycle_rule_transition(self, rule):
        ts = []
        for t in rule["transition"]:
            s = "    transition {\n"
            if t["date"] != "":
                s += f'''      date          = {t["date"]}\n'''
            if t["days"] != 0:
                s += f'''      days          = {t["days"]}\n'''
            s += f'''      storage_class = "{t["storage_class"]}"\n'''
            s += "    }"
            ts.append(s)
        return "\n".join(ts) + "\n"

    def _lifecycle_rule_expiration(self, rule):
        ts = []
        for t in rule["expiration"]:
            s = "    expiration {\n"
            if t["date"] != "":
                s += f'''      date          = {t["date"]}\n'''
            if t["days"] != 0:
                s += f'''      days                          = {t["days"]}\n'''
            s += f'''      expired_object_delete_marker  = {"true" if t["expired_object_delete_marker"] else "false"}\n'''
            s += "    }"
            ts.append(s)
        return "".join([t + "\n" for t in ts])

    def _lifecycle_rule_noncurrent_version_transition(self, rule):
        ts = []
        for t in rule["noncurrent_version_transition"]:
            s = "    noncurrent_version_transition {\n"
            # Not implemented in module
            # if t["newer_noncurrent_versions"] != 0:
            #     s += f'''      newer_noncurrent_versions = {t["newer_noncurrent_versions"]}\n'''
            if t["days"] != 0:
                s += f'''      noncurrent_days = {t["days"]}\n'''
            s += f'''      storage_class   = "{t["storage_class"]}"\n'''
            s += "    }"
            ts.append(s)
        return "".join([t + "\n" for t in ts])

    def _lifecycle_rule_noncurrent_version_expiration(self, rule):
        ts = []
        for t in rule["noncurrent_version_expiration"]:
            s = "    noncurrent_version_expiration {\n"
            # Not implemented in module
            # if t["newer_noncurrent_versions"] != 0:
            #     s += f'''      newer_noncurrent_versions = {t["newer_noncurrent_versions"]}\n'''
            s += f'''      noncurrent_days = {t["days"]}\n'''
            s += "    }"
            ts.append(s)
        return "".join([t + "\n" for t in ts])

    def convert_resource_lifecycle(self, resource):
        instance = resource["instances"][0]
        lifecycle_attr = instance["attributes"]["lifecycle_rule"]
        bucket = instance["attributes"]["bucket"]
        resource_prefix = ""
        if "module" in resource:
            resource_prefix = resource["module"] + "."
        module_line = f'# In module {resource["module"]}' + "\n" if "module" in resource else ""

        lifecycle_hcl = "\n".join([
            f"""  rule {{
    id     = "{r["id"]}"
    status = "{"Enabled" if r["enabled"] else "Disabled"}"
{self._lifecycle_rule_filter(r)}{self._lifecycle_rule_abort_multipart_incomplete_multipart_upload(r)}{self._lifecycle_rule_transition(r)}{self._lifecycle_rule_expiration(r)}{self._lifecycle_rule_noncurrent_version_transition(r)}{self._lifecycle_rule_noncurrent_version_expiration(r)}  }}"""
        for r in lifecycle_attr])

        lifecycle = f"""#{module_line}resource "aws_s3_bucket_lifecycle_configuration" "{resource["name"]}" {{
  bucket = aws_s3_bucket.{resource["name"]}.id
{lifecycle_hcl}
}}"""

        import_cmd = f"terraform import {resource_prefix}aws_s3_bucket_lifecycle_configuration.{resource['name']} {bucket}"
        return [import_cmd, lifecycle]

if __name__ == "__main__":
    S3StateConverter(sys.argv).main()
