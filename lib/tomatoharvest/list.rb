require 'yaml'

module TomatoHarvest
  class List
    FILENAME = 'list.yaml'

    attr_reader :items

    alias :all :items

    def self.list_path(dir)
      File.join(dir, FILENAME)
    end

    def self.local_or_global
      local_path  = list_path(TomatoHarvest::Config::LOCAL_DIR)
      global_path = list_path(TomatoHarvest::Config::GLOBAL_DIR)

      if File.exists? local_path
        new(local_path)
      else
        new(global_path)
      end
    end

    def initialize(path)
      @path = path
      if File.exists?(@path)
        @items = load_list
      else
        @items = []
      end
    end

    def find(id)
      all.find do |item|
        item.id == id.to_i
      end
    end

    def save
      dir = File.dirname(@path)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)

      yaml = YAML::dump(@items)
      File.open(@path, "w+") do |f|
        f.write(yaml)
      end
    end

    def add(item)
      if last_item = @items.last
        id = last_item.id
      else
        id = 0
      end
      item.id = id + 1

      @items << item
    end

    def remove(id)
      all.delete_if do |item|
        item.id == id.to_i
      end
    end

    private

    def load_list
      string = ""

      # better way to do this?
      File.open(@path, "r") do |f|
        while line = f.gets
          string += line
        end
      end

      YAML::load(string)
    end

  end
end
