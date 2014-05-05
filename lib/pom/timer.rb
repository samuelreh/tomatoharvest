require 'daemons'

module Pom
  class Timer

    def self.start(task_id, options = {})
      minutes    = options[:minutes]
      time_entry = options[:time_entry]
      notifier   = Notifier.new

      list = List.new
      task = list.find(task_id)

      if Daemons.daemonize(app_name: '.pom', dir: '~/', dir_mode: :normal)
        at_exit do
          list.save
          time_entry.log(task.logged_seconds / 60.0) if time_entry
        end
      end

      notifier.notify "Pomadoro started for #{minutes} minutes", :subtitle => task.name

      (minutes * 60).times do |i|
        sleep 1
        task.logged_seconds += 1
      end

      list.save
      time_entry.log(task.logged_seconds / 60.0) if time_entry

      notifier.notify "Pomadoro finished", :subtitle => "Pomadoro finished!"
    end

    def self.stop
      #kill it
    end

  end
end

