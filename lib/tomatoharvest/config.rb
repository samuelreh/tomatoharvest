module TomatoHarvest
  class Config
    DIR_NAME = '.toma'

    GLOBAL_DIR = File.join(ENV['HOME'], DIR_NAME)
    LOCAL_DIR  = File.join(Dir.pwd, DIR_NAME)

    def self.load(options = {})
      hash = {}

      global_config = config_path(GLOBAL_DIR)
      if File.exists? global_config
        hash.merge!(YAML.load_file(global_config))
      end

      local_config = config_path(LOCAL_DIR)
      if File.exists? local_config
        hash.merge!(YAML.load_file(local_config))
      end

      hash
    end

    def self.config_path(directory)
      File.join(directory, 'config.yaml')
    end
  end
end
