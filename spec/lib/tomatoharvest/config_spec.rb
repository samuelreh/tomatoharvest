require 'fileutils'
require 'helper'

describe TomatoHarvest::Config do

  describe '.load' do
    let(:global_options) do
      {
        project: 'Project',
        type:    'Ruby Development',
      }
    end

    before do
      path = TomatoHarvest::Config.config_path(TomatoHarvest::Config::GLOBAL_DIR)
      create_yaml_file(path, global_options)
    end

    it 'loads from the yaml config file' do
      expect(TomatoHarvest::Config.load).to eql(global_options)
    end

    context 'when there is a config file in the current dir' do

      it 'overrides global config' do
        options = {
          type:    'JS Development',
        }

        path = TomatoHarvest::Config.config_path(TomatoHarvest::Config::LOCAL_DIR)
        create_yaml_file(path, options)

        expected = global_options.merge(options)

        expect(TomatoHarvest::Config.load).to eql(expected)
      end

    end

  end

end
