###
## Gitorio
###

MOD_NAME := gitorio
MOD_VERSION := $(shell python -c "import sys,json;sys.stdout.write(json.load(open('$(CURDIR)/gitorio/info.json'))['version'])")
MOD_FULL_NAME := $(MOD_NAME)_$(MOD_VERSION)
BUILD_DIR := _build
MOD_BUILD_DIR := $(BUILD_DIR)/$(MOD_FULL_NAME)

ifeq "$(OS)" "Windows_NT"
  $(info ### Building for windows ###)
  MOD_ZIP := $(MOD_BUILD_DIR).zip
  FACTORIO_INSTALL_DIR := $(APPDATA)/Factorio/mods
  DEPLOYED_ZIP := $(FACTORIO_INSTALL_DIR)/$(MOD_FULL_NAME).zip
  ZIP_COMMAND = powershell -File $(CURDIR)/bin/zip.ps1 -directory $< -output $@
else
  $(info ### Building for a proper OS ###)
  $(error Build not implemented yet for this platform)
  ## TODO
  #MOD_ZIP := $(MOD_BUILD_DIR).zip
  #FACTORIO_INSTALL_DIR := $(APPDATA)/Factorio/mods
  #DEPLOYED_ZIP := $(FACTORIO_INSTALL_DIR)/$(MOD_FULL_NAME).zip
  #ZIP_COMMAND = powershell -File $(CURDIR)/bin/zip.ps1 -directory $< -output $@
endif
 

all: $(MOD_ZIP)

$(MOD_ZIP): $(MOD_BUILD_DIR) clean
	@echo "zip up the directory here..."
	$(ZIP_COMMAND)

$(MOD_BUILD_DIR): clean | $(BUILD_DIR)
	cp -R $(MOD_NAME) $(MOD_BUILD_DIR)

$(BUILD_DIR):
	mkdir $@

clean:
	rm -rf $(BUILD_DIR)

deploy: $(DEPLOYED_ZIP)

$(DEPLOYED_ZIP): $(MOD_ZIP) FORCE
	cp $(MOD_ZIP) $(DEPLOYED_ZIP)

tag: FORCE
	git tag -a $(MOD_VERSION) -m " Release $(MOD_VERSION)"

dev_tag: FORCE
	git tag -a v$(MOD_VERSION)-dev -m "Begin $(MOD_VERSION) development"

FORCE: ;
