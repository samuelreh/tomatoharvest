require 'helper'

describe TomatoHarvest::Timer do

  describe '.start' do

    let(:task) { TomatoHarvest::Task.new('foo') }

    before do
      list = TomatoHarvest::List.new
      list.add(task)
      list.save
    end

    def stub_notifier(minutes)
      message = "TomatoHarvestodoro started for #{minutes} minutes"
      options = {:title=>"TomatoHarvest", :subtitle=> 'foo'}
      TerminalNotifier.should_receive(:notify).with(message, options)

      message = "TomatoHarvestodoro finished"
      options = {:title=>"TomatoHarvest", :subtitle=> 'TomatoHarvestodoro finished!'}
      TerminalNotifier.should_receive(:notify).with(message, options)
    end

    it 'can run for a custom length' do
      TomatoHarvest::Timer.start(task.id, minutes: 15)

      reloaded_task = TomatoHarvest::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(15.0)
    end

    it 'can be run twice' do
      TomatoHarvest::Timer.start(task.id, minutes: 20)
      TomatoHarvest::Timer.start(task.id, minutes: 20)
      reloaded_task = TomatoHarvest::List.find(task.id)
      expect(reloaded_task.logged_minutes).to eql(40.0)
    end

    it 'logs a time entry if passed in' do
      entry = double
      entry.should_receive(:log)
      TomatoHarvest::Timer.start(task.id, time_entry: entry, minutes: 25)
    end

  end

end
