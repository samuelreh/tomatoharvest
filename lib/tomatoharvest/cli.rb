require 'thor'

module TomatoHarvest
  class CLI < ::Thor
    DEFAULT_MINUTES = 25

    desc "add", "add a task"
    def add(name)
      list = ListLoader.from_file
      task = Task.new(name)
      list.add(task)
      list.save!
      say "#{task.name} added with id #{task.id}"
    end

    desc "list", "list all tasks"
    def list
      list  = ListLoader.from_file
      table = list.map do |task|
        [task.id, task.name]
      end
      table.unshift(['id', 'name'])

      shell = Thor::Base.shell.new
      shell.print_table(table)
    end

    desc "start", "start a task"
    def start(id, minutes = DEFAULT_MINUTES)
      list    = ListLoader.from_file
      task    = list.find(id)
      config  = Config.load.merge("name" => task.name)
      entry   = TimeEntry.build_and_test(config)

      say "Timer started for #{task.name}"
      Timer.start(list, task.id, minutes: minutes, time_entry: entry)
    end

    desc "stop", "stop current timer"
    def stop
      if Timer.stop
        say "Timer stopped"
      else
        say "Timer not running"
      end
    end

    desc "remove", "remove a task"
    def remove(id)
      list = ListLoader.from_file
      task = list.remove(id)
      list.save!
      say "#{id} removed"
    end

  end
end
