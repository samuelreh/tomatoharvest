module TomatoHarvest
  class Config
    CONFIG_PATH = File.expand_path("#{ENV['$HOME']}/.tomaconfig")

    def self.load(options = {})
      if !(File.exists? CONFIG_PATH)
        File.open(CONFIG_PATH, 'w') do |file|
          YAML.dump({}, file)
        end
      end

      YAML.load_file(CONFIG_PATH)
    end
  end
end
