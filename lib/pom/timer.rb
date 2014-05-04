module Pom
  class Timer

    DEFAULT_MINUTES = 25

    def initialize(task_id)
      @task_id = task_id
    end

    def start(minutes = nil)
      minutes ||= DEFAULT_MINUTES
      list = List.new

      Process.daemon

      task = list.find(@task_id)
      while (minutes * 60) > task.logged_seconds do
        sleep 1
        task.logged_seconds += 1
        list.save
      end
    end

    def self.stop
      #kill it
    end

  end
end

