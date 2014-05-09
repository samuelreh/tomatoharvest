require 'helper'

describe TomatoHarvest::CLI do

  describe 'add' do

    it 'adds a task to the list' do
      out = capture_io { TomatoHarvest::CLI.start ['add', 'foo'] }.join ''
      expect(out).to match(/foo added with id 1/)
    end

  end

  describe 'list' do

    it 'shows a table of the tasks' do
      TomatoHarvest::CLI.start ['add', 'foo']
      TomatoHarvest::CLI.start ['add', 'bar']
      out = capture_io { TomatoHarvest::CLI.start ['list'] }.join ''
      expect(out).to match(/id  name\n\s*1  foo\n\s*2  bar/)
    end

  end

  describe 'start' do
    before do
      TomatoHarvest::CLI.start ['add', 'foo']
    end

    it 'starts the timer' do
      out = capture_io { TomatoHarvest::CLI.start ['start', 1] }.join ''
      expect(out).to match(/Timer started for foo/)
    end

    it 'starts the timer with specified length' do
      out = capture_io { TomatoHarvest::CLI.start ['start', 1, 15] }.join ''
      expect(out).to match(/Timer started for foo/)
    end

    context 'when config has valid harvest options' do

      before do
        options = {
          project:  'Pomodoro',
          type:     'Ruby Development',
          domain:   'domain',
          username: 'user',
          password: 'password'
        }

        path = TomatoHarvest::Config::CONFIG_PATH
        File.open(path, 'w') do |file|
          YAML::dump(options, file)
        end
      end

      it 'starts the timer with specified length' do
        out = capture_io { TomatoHarvest::CLI.start ['start', 1] }.join ''
        expect(out).to match(/Timer started for foo/)
      end

    end

  end

end
