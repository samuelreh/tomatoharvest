module Pom
  class Config
    def self.load(options = {})
      path = File.expand_path('spec/.pomrc')

      if !(File.exists? path)
        File.open(path, 'w') do |file|
          YAML::dump({}, file)
        end
      end

      YAML.load_file(path)
    end
  end
end
