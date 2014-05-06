require 'helper'

describe Pom::Timer do

  describe '.start' do

    let(:task) { Pom::Task.new('foo') }

    before do
      list = Pom::List.new
      list.add(task)
      list.save
    end

    def stub_notifier(minutes)
      message = "Pomodoro started for #{minutes} minutes"
      options = {:title=>"Pom", :subtitle=> 'foo'}
      TerminalNotifier.should_receive(:notify).with(message, options)

      message = "Pomodoro finished"
      options = {:title=>"Pom", :subtitle=> 'Pomodoro finished!'}
      TerminalNotifier.should_receive(:notify).with(message, options)
    end

    it 'can run for a custom length' do
      Pom::Timer.start(task.id, minutes: 15)

      reloaded_task = Pom::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(15.0)
    end

    it 'can be run twice' do
      Pom::Timer.start(task.id, minutes: 20)
      Pom::Timer.start(task.id, minutes: 20)
      reloaded_task = Pom::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(40.0)
    end

    it 'logs a time entry if passed in' do
      entry = double
      entry.should_receive(:log)
      Pom::Timer.start(task.id, time_entry: entry, minutes: 25)
    end

  end

end
