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

    context 'when there is an old config file' do

      let(:old_config) do
        {
          domain: 'fake.domain.name'
        }
      end

      it 'loads it' do
        old_config_path = File.join(TomatoHarvest::Config::HOME_DIR, '.tomaconfig')
        expanded_path = File.expand_path(old_config_path)
        create_yaml_file(expanded_path, old_config)

        expected = old_config.merge(global_options)
        expect(TomatoHarvest::Config.load).to eql(expected)

        File.delete(old_config_path)
      end

    end

  end

end
