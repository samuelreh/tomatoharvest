module FileHelpers

  # Creates a YAML config file at the specified path.
  def create_yaml_file(path, options)
    create_file(path, YAML::dump(options))
  end

  def create_file(path, contents)
    dir = File.dirname(path)

    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    File.open(path, 'w') do |file|
      file.write(contents)
    end
  end

end
