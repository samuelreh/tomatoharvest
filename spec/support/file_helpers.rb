module FileHelpers

  # Creates a YAML config file at the specified path.
  def create_yaml_file(path, options)
    dir = File.dirname(path)

    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    File.open(path, 'w') do |file|
      YAML::dump(options, file)
    end
  end

end
