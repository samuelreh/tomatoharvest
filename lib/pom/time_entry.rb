require 'set'
require 'harvested'

module Pom
  class TimeEntry

    attr_accessor :options

    def self.build_and_test(options = {})
      required = [:domain, :username, :password, :project, :type].to_set
      keys = options.keys.to_set
      if required.subset?(keys)
        new(options).tap do |entry|
          entry.test
        end
      end
    end

    def initialize(options = {})
      self.options = options
    end

    ##
    # Check that the project and task were found on Harvest

    def test
      raise "Couldn't find project"   unless project
      raise "Couldn't find task type" unless task
    end

    ##
    # Persist time entry to Harvest tracker

    def log(minutes)
      hours = minutes_to_hours(minutes)
      options = {
        notes: notes,
        hours: hours,
        spent_at: date,
        project_id: project.id,
        task_id: task.id
      }
      entry = Harvest::TimeEntry.new(options)
      harvest.time.create(entry)
    end

    ##
    # Notes to send to tracker

    def notes
      options[:name]
    end

    ##
    # Date for task (today), formatted properly for tracker

    def date
      Date.today.strftime("%d/%m/%Y")
    end

    ##
    # Convert minutes into hours

    def minutes_to_hours(minutes)
      unrounded = (minutes / 60.0)
      (unrounded * 100).ceil / 100.0
    end

    ##
    # Harvest project with name matching options[:project]

    def project
      time_api = Harvest::API::Time.new(harvest.credentials)
      time_api.trackable_projects.find do |project|
        project.name == options[:project]
      end
    end

    ##
    # Harvest task with name matching options[:task]

    def task
      project.tasks.find do |task|
        task.name == options[:type]
      end
    end

    private

    def harvest
      @harvest ||= Harvest.client(options[:domain], options[:username], options[:password])
    end

  end
end
