require 'helper'

describe Pom::Config do

  describe '.load' do

    before do
      path = Pom::Config::CONFIG_PATH = File.expand_path('spec/.pomrc')
      File.delete(path) if File.exists?(path)
    end

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
