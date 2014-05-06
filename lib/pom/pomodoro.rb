module Pom
  class Pomodoro
    attr_accessor :seconds, :finished_at

    def initialize(seconds, finished_at)
      @seconds = seconds
      @finished_at = finished_at
    end
  end
end
