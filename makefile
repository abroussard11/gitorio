###
## Gitorio
###

MOD_NAME := gitorio
MOD_VERSION := $(shell python -c "import sys,json;sys.stdout.write(json.load(open('gitorio/info.json'))['version'])")

BUILD_DIR := _build
MOD_DIR := $(BUILD_DIR)/$(MOD_NAME)_$(MOD_VERSION)
MOD_ZIP := $(MOD_DIR).zip

FACTORIO_INSTALL_DIR := $(APPDATA)/Factorio/mods

all: $(MOD_ZIP)
	@echo "Hello $(MOD_VERSION)"

$(MOD_ZIP): $(MOD_DIR)
	@echo "zip up the directory here..."
	powershell -File $(PWD)/bin/zip.ps1 -directory $< -output $@

$(MOD_DIR): | $(BUILD_DIR)
	cp -R $(MOD_NAME) $(MOD_DIR)

$(BUILD_DIR):
	mkdir $@

clean:
	rm -rf $(BUILD_DIR)

deploy:
	cp $(MOD_ZIP) $(FACTORIO_INSTALL_DIR)/$(MOD_NAME)_$(MOD_VERSION).zip
