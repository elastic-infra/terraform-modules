# S3 converter

## Usage

1. Backup your tfstate with AWS provider v3.

```console
terraform state pull > terraform.tfstate.v3
```

2. Update provider to v4 and module to v4.

3. Import S3-attribute resources generated by `s3_converter`.

```console
./s3_converter convert-v4 < terraform.tfstate.v3
```

4. Ensure no drift is detected

```console
terraform plan
```

NOTE: S3 bucket canned ACL is not imported with `terraform import`.