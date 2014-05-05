require 'thor'

module Pom
  class CLI < ::Thor
    DEFAULT_MINUTES = 25

    desc "add", "add a task"
    def add(name)
      task = Task.new(name)
      List.add(task)
      say "#{task.name} added with id #{task.id}"
    end

    desc "list", "list all tasks"
    def list
      list = List.all.map do |task|
        [task.id, task.name]
      end
      list.unshift(['id', 'name'])

      shell = Thor::Base.shell.new
      shell.print_table(list)
    end

    desc "start", "start a task"
    def start(id, minutes = DEFAULT_MINUTES)
      task    = List.find(id)
      config  = Config.load
      entry   = TimeEntry.build_and_test(config)

      say "Timer started for #{task.name}"
      Timer.start(task.id, minutes: minutes, time_entry: entry)
    end

    desc "stop", "stop current timer"
    def stop
      Timer.stop
      say "Timer stopped"
    end


  end
end
