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
      File.open(TomatoHarvest::Config::CONFIG_PATH, 'w') do |file|
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
        local_config = File.join(Dir.pwd, '.tomaconfig')

        File.open(local_config, 'w') do |file|
          YAML::dump(options, file)
        end

        result = global_options.merge(options)

        expect(TomatoHarvest::Config.load).to eql(result)
      end

    end

  end

end
