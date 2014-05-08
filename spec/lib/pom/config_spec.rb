require 'helper'

describe Pom::Config do

  describe '.load' do

    it 'loads from the yaml config file' do
      options = {
        project: 'Project',
        type:    'Ruby Development',
      }
      File.open(Pom::Config::CONFIG_PATH, 'w') do |file|
        YAML::dump(options, file)
      end

      expect(Pom::Config.load).to eql(options)
    end

  end

end
