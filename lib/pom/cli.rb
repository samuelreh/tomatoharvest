require 'thor'

module Pom
  class CLI < ::Thor

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
    def start(id, length = nil)
      task = List.find(id)
      say "Timer started for #{task.name}"
      Timer.new(task.id).start(length)
    end

    desc "stop", "stop current timer"
    def stop
      Timer.stop
      say "Timer stopped"
    end


  end
end
