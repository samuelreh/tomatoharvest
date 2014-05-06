$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'thor'
require 'pom'

require 'webmock/rspec'
require 'minitest/unit'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.include MiniTest::Assertions

  # speed up the timer
  c.before :all do
    class Pom::Timer
      def sleep(time)
        super(time/100000)
      end
    end
  end

  c.before do
    body = {
      projects: [ {
        name: 'Pomodoro',
        id: 1,
        tasks: [
          {
            name: 'Ruby Development',
            id: 1
          }
        ]
      } ],
      day_entries: []
    }

    stub_request(:get, /https:\/\/user:password@domain.harvestapp.com\/daily\/.*/).
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json; charset=utf-8', 'User-Agent'=>'Harvestable/2.0.0'}).
      to_return(:status => 200, :body => body.to_json, :headers => {})

    stub_request(:post, "https://user:password@domain.harvestapp.com/daily/add").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json; charset=utf-8', 'User-Agent'=>'Harvestable/2.0.0'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  # TODO find a better way to stub Daemon
  c.before do
    Daemons.stub(daemonize: false)
    TerminalNotifier.stub(notify: true)
  end

  path = 'spec/.pom'
  Pom::List::PATH = File.expand_path(path)

  c.before :each do
    File.delete(path) if File.exists?(path)
  end

  c.after :each do
    File.delete(path) if File.exists?(path)
  end
end
