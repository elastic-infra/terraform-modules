ALL: fmt docs

.PHONY: fmt docs

fmt:
	terraform fmt

docs:
	docker run --rm -v $(shell pwd):/data cytopia/terraform-docs terraform-docs-replace-012 --sort-by-required markdown README.md
