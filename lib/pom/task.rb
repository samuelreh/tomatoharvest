module Pom
  class Task

    attr_reader :name
    attr_accessor :id, :logged_seconds

    def initialize(name)
      @name = name
      @logged_seconds = 0
    end

    def logged_minutes
      logged_seconds / 60.0
    end

  end
end
