require 'helper'

describe Pom::Timer do

  describe '.start' do

    let(:task) { Pom::Task.new('foo') }
    let(:timer) { Pom::Timer.new(task.id) }

    before do
      list = Pom::List.new
      list.add(task)
      list.save
    end

    it 'starts the timer for the default time' do
      timer.start

      reloaded_task = Pom::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(25.0)
    end

    it 'can run for a custom length' do
      timer.start(15)

      reloaded_task = Pom::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(15.0)
    end

    #describe '.stop' do

      #it 'logs only the amount of time elapsed' do
        #timer.start
        #sleep(0.5)
        #timer.stop

        #reloaded_task = Pom::List.find(task.id)
        #expect(reloaded_task.logged_minutes).to_not eql(0.0)
        #expect(reloaded_task.logged_minutes).to_not eql(25.0)
      #end

    #end

  end

end
