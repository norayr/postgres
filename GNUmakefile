VOC = /opt/voc/bin/voc
BUILD=build
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir_path := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

all:
			mkdir -p $(BUILD)
			cd $(BUILD) && $(VOC) -s $(mkfile_dir_path)/src/postgres.Mod
			cd $(BUILD) && $(VOC) -m $(mkfile_dir_path)/src/postgresTests.Mod

clean:
			if [ -d "$(BUILD)" ]; then rm -rf $(BUILD); fi
