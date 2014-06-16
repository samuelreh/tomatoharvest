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
      global_dir = TomatoHarvest::Config::GLOBAL_DIR
      FileUtils.mkdir_p(global_dir) unless File.directory?(global_dir)
      path = TomatoHarvest::Config.config_path(global_dir)
      File.open(path, 'w') do |file|
        YAML::dump(global_options, file)
      end
    end

    it 'loads from the yaml config file' do
      expect(TomatoHarvest::Config.load).to eql(global_options)
    end

    context 'when there is a config file in the current dir' do

      it 'overrides global config' do
        options = {
          type:    'JS Development',
        }

        local_dir = TomatoHarvest::Config::LOCAL_DIR
        FileUtils.mkdir_p(local_dir) unless File.directory?(local_dir)
        path = TomatoHarvest::Config.config_path(local_dir)
        File.open(path, 'w') do |file|
          YAML::dump(options, file)
        end

        expected = global_options.merge(options)

        expect(TomatoHarvest::Config.load).to eql(expected)
      end

    end

  end

end
