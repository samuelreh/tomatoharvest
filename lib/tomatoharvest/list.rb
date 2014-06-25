require 'yaml'
require 'forwardable'

module TomatoHarvest
  class List
    extend ::Forwardable

    attr_reader :items

    def_delegators :items, :count, :map

    def self.init_and_load(*args)
      new(*args).load!
    end

    def initialize(path, items = nil)
      @path  = path
      @items = items || []
    end

    def load!
      if File.exists?(@path) && items = YAML.load_file(@path)
        @items = items
      end
      
      self
    end

    def find(id)
      @items.find do |item|
        item.id == id.to_i
      end
    end

    def save!
      dir = File.dirname(@path)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)

      yaml = YAML.dump(@items)
      File.open(@path, "w+") do |f|
        f.write(yaml)
      end

      self
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
      @items.delete_if do |item|
        item.id == id.to_i
      end
    end

  end
end
