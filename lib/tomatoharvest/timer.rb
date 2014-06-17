require 'daemons'

module TomatoHarvest
  class Timer
    PID_DIR = '~'
    PID_NAME = '.toma'

    def self.start(*args)
      new(*args).start
    end

    def self.stop
      if monitor = Daemons::Monitor.find(File.expand_path(DIR), APP_NAME)
        monitor.stop
        true
      end
    end

    def initialize(list, task_id, options = {})
      @minutes    = options[:minutes]
      @time_entry = options[:time_entry]
      @notifier   = Notifier.new
      @list       = list
      @task       = @list.find(task_id)
      @timer      = 0
      @tmux       = Tmux.new
    end

    def start
      if Daemons.daemonize(app_name: PID_NAME, dir: PID_DIR, dir_mode: :normal)
        at_exit { save_and_log }
        run_timer
      else
        run_timer
        save_and_log
      end
    end

    private

    def run_timer
      @notifier.notify "Pomodoro started for #{@minutes} minutes", :subtitle => @task.name

      (@minutes * 60).times do |i|
        sleep 1
        @timer += 1
        @tmux.update(@timer)
      end
    end

    def save_and_log
      @task.log_pomodoro(@timer)
      @list.save
      @time_entry.log(@timer) if @time_entry
      @notifier.notify "Pomodoro finished", :subtitle => "Pomodoro finished!"
      @tmux.update(0)
    end

  end
end

