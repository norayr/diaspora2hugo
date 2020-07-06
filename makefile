mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
build_dir_path := $(mkfile_dir_path)/build
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
#.ONESHELL
BLD := $(mkfile_dir_path)/build

all:
		mkdir -p $(CURDIR)/$(BUILD)
		cd $(CURDIR)/$(BUILD)
		make -f $(mkfile_dir_path)/dps/lists/makefile BUILD=$(BLD)
		make -f $(mkfile_dir_path)/dps/pipes/makefile BUILD=$(BLD)
		make -f $(mkfile_dir_path)/dps/postgres/makefile BUILD=$(BLD)
		make -f $(mkfile_dir_path)/dps/diaspora/makefile BUILD=$(BLD)
		cd build && voc ../src/d2h.Mod -m
clean:
		cd $(BLD) && rm *
