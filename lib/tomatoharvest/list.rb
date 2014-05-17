require 'yaml'

module TomatoHarvest
  class List
    PATH = File.expand_path("#{ENV['$HOME']}/.toma")

    attr_reader :items

    alias :all :items

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

    def self.remove(id)
      new.tap do |list|
        list.remove(id)
        list.save
      end
    end

    def initialize
      if File.exists?(PATH)
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

    def save
      yaml = YAML::dump(@items)
      File.open(PATH, "w+") do |f|
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
      File.open(PATH, "r") do |f|
        while line = f.gets
          string += line
        end
      end

      YAML::load(string)
    end

  end
end

