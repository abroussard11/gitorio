###
## Gitorio
###

MOD_NAME := gitorio
MOD_VERSION := $(shell python -c "import sys,json;sys.stdout.write(json.load(open('$(CURDIR)/gitorio/info.json'))['version'])")
MOD_FULL_NAME := $(MOD_NAME)_$(MOD_VERSION)
BUILD_DIR := _build
MOD_BUILD_DIR := $(BUILD_DIR)/$(MOD_FULL_NAME)

ifeq "$(OS)" "Windows_NT"
  $(info ### Building for Windows ###)
  MOD_ZIP := $(MOD_BUILD_DIR).zip
  FACTORIO_INSTALL_DIR := $(APPDATA)/Factorio/mods
  DEPLOYED_ZIP := $(FACTORIO_INSTALL_DIR)/$(MOD_FULL_NAME).zip
  ZIP_COMMAND = powershell -File $(CURDIR)/bin/zip.ps1 -directory $< -output $@
else
  $(info ### Building for a proper OS ###)
  MOD_ZIP := $(MOD_BUILD_DIR).zip
  MOD_ZIP_REALPATH := $(shell readlink -m $(MOD_ZIP))
  FACTORIO_INSTALL_DIR := ~/.factorio/mods
  DEPLOYED_ZIP := $(FACTORIO_INSTALL_DIR)/$(MOD_FULL_NAME).zip
  ZIP_COMMAND := cd $(dir $(MOD_BUILD_DIR)) && zip -r $(MOD_ZIP_REALPATH) $(notdir $(MOD_BUILD_DIR))
endif

## 3rd-Party libs
STDLIB.NAME := Factorio-Stdlib
STDLIB.VERSION := 0.8.0
STDLIB.USER := Afforess
STDLIB.ZIP := $(BUILD_DIR)/$(STDLIB.NAME)-$(STDLIB.VERSION).tar.gz
STDLIB.URL := https://github.com/$(STDLIB.USER)/$(STDLIB.NAME)/archive/$(STDLIB.VERSION).tar.gz
STDLIB.BUILD_DIR := $(MOD_BUILD_DIR)/stdlib

all: $(MOD_ZIP)

$(MOD_ZIP): FORCE
$(MOD_ZIP): $(MOD_BUILD_DIR) $(STDLIB.BUILD_DIR)
	@echo "zip up the directory here..."
	rm -rf $@
	$(ZIP_COMMAND)

$(MOD_BUILD_DIR): FORCE
$(MOD_BUILD_DIR): | $(BUILD_DIR)
	rm -rf $(MOD_BUILD_DIR)
	cd $(dir $@) && mkdir $(notdir $@)
	cp -R $(MOD_NAME)/* --target-directory=$(MOD_BUILD_DIR)

$(BUILD_DIR):
	mkdir $@

clean:
	rm -rf $(BUILD_DIR)

deploy: $(DEPLOYED_ZIP)

$(DEPLOYED_ZIP): FORCE
$(DEPLOYED_ZIP): $(MOD_ZIP)
	cp $(MOD_ZIP) $(DEPLOYED_ZIP)


$(STDLIB.ZIP): | $(BUILD_DIR)
	curl -L $(STDLIB.URL) -o $(STDLIB.ZIP)

stdlib: $(STDLIB.BUILD_DIR)
$(STDLIB.BUILD_DIR): FORCE
$(STDLIB.BUILD_DIR): $(STDLIB.ZIP) $(MOD_BUILD_DIR)
	tar --overwrite -xzf $(STDLIB.ZIP) -C $(MOD_BUILD_DIR) $(STDLIB.NAME)-$(STDLIB.VERSION)/stdlib --strip-components=1

tag: FORCE
	git tag -a $(MOD_VERSION) -m " Release $(MOD_VERSION)"

dev_tag: FORCE
	git tag -a v$(MOD_VERSION)-dev -m "Begin $(MOD_VERSION) development"

FORCE: ;
