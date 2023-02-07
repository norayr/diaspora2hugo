VOC = /opt/voc/bin/voc
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
build_dir_path := $(mkfile_dir_path)/build
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
#.ONESHELL
BLD := $(mkfile_dir_path)/build
DPS := $(mkfile_dir_path)/dps

all: get_deps build_deps

get_deps:
		mkdir -p $(DPS)
		if [ -d $(DPS)/lists ]; then cd $(DPS)/lists; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/lists; cd -; fi
		if [ -d $(DPS)/pipes ]; then cd $(DPS)/pipes; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/pipes; cd -; fi
		if [ -d $(DPS)/postgres ]; then cd $(DPS)/postgres; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/postgres; cd -; fi
		if [ -d $(DPS)/diaspora ]; then cd $(DPS)/diaspora; git pull; cd -; else cd $(DPS); git clone https://github.com/norayr/diaspora; cd -; fi

build_deps:
		mkdir -p $(CURDIR)/$(BUILD)
		cd $(CURDIR)/$(BUILD)
		make -f $(DPS)/lists/GNUmakefile BUILD=$(BLD)
		make -f $(DPS)/pipes/GNUmakefile BUILD=$(BLD)
		make -f $(DPS)/postgres/GNUmakefile BUILD=$(BLD)
		make -f $(DPS)/diaspora/GNUmakefile BUILD=$(BLD)
		cd build && $(VOC) ../src/d2h.Mod -m
clean:
		if [ -d "$(BUILD)" ]; then rm -rf $(BUILD); fi
