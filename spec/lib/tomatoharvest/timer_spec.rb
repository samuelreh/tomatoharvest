require 'helper'

describe TomatoHarvest::Timer do

  describe '.start' do

    let(:task) { TomatoHarvest::Task.new('foo') }

    let(:list) do
      path = TomatoHarvest::ListLoader.global_path
      TomatoHarvest::List.new(path)
    end

    before do
      list.add(task)
      list.save!
    end

    def stub_notifier(minutes)
      message = "Pomodoro started for #{minutes} minutes"
      options = {:title=>"TomatoHarvest", :subtitle=> 'foo'}
      TerminalNotifier.should_receive(:notify).with(message, options)

      message = "Pomodoro finished"
      options = {:title=>"TomatoHarvest", :subtitle=> 'Pomodoro finished!'}
      TerminalNotifier.should_receive(:notify).with(message, options)
    end

    it 'can run for a custom length' do
      TomatoHarvest::Timer.start(list, task.id, minutes: 15)

      reloaded_task = list.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(15.0)
    end

    it 'can be run twice' do
      TomatoHarvest::Timer.start(list, task.id, minutes: 20)
      TomatoHarvest::Timer.start(list, task.id, minutes: 20)
      reloaded_task = list.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(40.0)
    end

    it 'logs a time entry if passed in' do
      entry = double
      expect(entry).to receive(:log)
      TomatoHarvest::Timer.start(list, task.id, time_entry: entry, minutes: 25)
    end

  end

end
