module TomatoHarvest
  class Config
    DIR_NAME = '.toma'

    HOME_DIR   = ENV['HOME']
    GLOBAL_DIR = File.join(HOME_DIR, DIR_NAME)
    LOCAL_DIR  = File.join(Dir.pwd, DIR_NAME)

    def self.load
      old_config    = merge_config(old_config_path)

      global_path = config_path(GLOBAL_DIR)
      global_config = merge_config(global_path, old_config)

      local_path = config_path(LOCAL_DIR)
      merge_config(local_path, global_config)
    end

    def self.merge_config(path, base = {})
      mergable =
        if File.exists?(path) 
          YAML.load_file(path)
        else
          {}
        end

      base.merge(mergable)
    end

    def self.config_path(directory)
      File.join(directory, 'config.yaml')
    end

    def self.old_config_path
      File.join(HOME_DIR, '.tomaconfig')
    end
  end
end
