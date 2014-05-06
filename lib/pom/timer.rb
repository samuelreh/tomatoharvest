require 'daemons'

module Pom
  class Timer
    DIR = '~'
    APP_NAME = '.pom'

    def self.start(task_id, options = {})
      new(task_id, options).start
    end

    def self.stop
      if monitor = Daemons::Monitor.find(File.expand_path(DIR), APP_NAME)
        monitor.stop
        true
      end
    end

    def initialize(task_id, options = {})
      @minutes    = options[:minutes]
      @time_entry = options[:time_entry]
      @notifier   = Notifier.new
      @list       = List.new
      @task       = @list.find(task_id)
      @timer      = 0
    end

    def start
      if Daemons.daemonize(app_name: APP_NAME, dir: DIR, dir_mode: :normal)
        at_exit { save_and_log }
      end

      @notifier.notify "Pomodoro started for #{@minutes} minutes", :subtitle => @task.name

      (@minutes * 60).times do |i|
        sleep 1
        @timer += 1
      end

      save_and_log
    end

    private

    def save_and_log
      @task.log_pomodoro(@timer)
      @list.save
      @time_entry.log(@timer) if @time_entry
      @notifier.notify "Pomodoro finished", :subtitle => "Pomodoro finished!"
    end

  end
end

