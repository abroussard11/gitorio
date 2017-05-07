###
## Gitorio
###

MOD_NAME := gitorio
MOD_VERSION := $(shell python -c "import sys,json;sys.stdout.write(json.load(open('gitorio/info.json'))['version'])")

BUILD_DIR := _build
MOD_DIR := $(BUILD_DIR)/$(MOD_NAME)_$(MOD_VERSION)
MOD_ZIP := $(MOD_DIR).zip

FACTORIO_INSTALL_DIR := $(APPDATA)/Factorio/mods
DEPLOYED_ZIP := $(FACTORIO_INSTALL_DIR)/$(MOD_NAME)_$(MOD_VERSION).zip

all: $(MOD_ZIP)

$(MOD_ZIP): $(MOD_DIR) clean
	@echo "zip up the directory here..."
	powershell -File $(PWD)/bin/zip.ps1 -directory $< -output $@

$(MOD_DIR): clean | $(BUILD_DIR)
	cp -R $(MOD_NAME) $(MOD_DIR)

$(BUILD_DIR):
	mkdir $@

clean:
	rm -rf $(BUILD_DIR)

deploy: $(DEPLOYED_ZIP)

$(DEPLOYED_ZIP): $(MOD_ZIP) FORCE
	cp $(MOD_ZIP) $(DEPLOYED_ZIP)

FORCE: ;
