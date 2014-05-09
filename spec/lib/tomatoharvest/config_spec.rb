require 'helper'

describe TomatoHarvest::Config do

  describe '.load' do

    it 'loads from the yaml config file' do
      options = {
        project: 'Project',
        type:    'Ruby Development',
      }
      File.open(TomatoHarvest::Config::CONFIG_PATH, 'w') do |file|
        YAML::dump(options, file)
      end

      expect(TomatoHarvest::Config.load).to eql(options)
    end

  end

end
