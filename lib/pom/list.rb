require 'yaml'

module Pom
  class List
    PATH = '~/.pom'

    attr_reader :items

    alias :all :items

    # might be nice if list didnt know about item
    def self.add(item)
      new.tap do |list|
        list.add(item)
        list.save
      end
    end

    def self.all
      new.all
    end

    def self.find(id)
      new.find(id)
    end

    def initialize(path = PATH)
      @path = path

      if File.exists?(full_path)
        @items = load_list
      else
        @items = []
      end
    end

    def find(id)
      # TODO speed this up with an algo
      all.find do |item|
        item.id == id.to_i
      end
    end

    def full_path
      File.expand_path(@path)
    end

    def save
      yaml = YAML::dump(@items)
      File.open(full_path, "w+") do |f|
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

    private

    def load_list
      string = ""

      # better way to do this?
      File.open(full_path, "r") do |f|
        while line = f.gets
          string += line
        end
      end

      YAML::load(string)
    end

  end
end

