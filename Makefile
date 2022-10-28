.PHONY: content

content:
	@read -p  "Content name: " NAME; \
	hugo new post/$$NAME.md
