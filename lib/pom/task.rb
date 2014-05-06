module Pom
  class Task

    attr_reader :name
    attr_accessor :id, :pomodoros

    def initialize(name)
      @name = name
      @pomodoros = []
    end

    def log_pomodoro(seconds)
      finished_at = DateTime.now
      self.pomodoros << Pomodoro.new(seconds, finished_at)
    end

    def logged_minutes
      sum = pomodoros.inject(0) do |sum, pomodoro|
        sum + pomodoro.seconds
      end

      sum / 60.0
    end

  end
end
