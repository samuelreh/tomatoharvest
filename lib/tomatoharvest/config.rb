module TomatoHarvest
  class Config
    CONFIG_PATH = File.expand_path("#{ENV['$HOME']}/.tomaconfig")
    LOCAL_CONFIG_PATH = File.join(Dir.pwd, '.tomaconfig')

    def self.load(options = {})
      if !(File.exists? CONFIG_PATH)
        File.open(CONFIG_PATH, 'w') do |file|
          YAML.dump({}, file)
        end
      end

      hash = YAML.load_file(CONFIG_PATH)
      if File.exists? LOCAL_CONFIG_PATH
        hash.merge!(YAML.load_file(LOCAL_CONFIG_PATH))
      end

      hash
    end
  end
end
