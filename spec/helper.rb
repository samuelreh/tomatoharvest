$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'thor'
require 'pom'

require 'webmock/rspec'
require 'minitest/unit'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.mock_framework = :rspec
  c.include MiniTest::Assertions

  #
  # Speed up the timer
  #
  c.before :all do
    class Pom::Timer
      def sleep(time)
        super(time/100000)
      end
    end
  end

  #
  # Stub HTTP requests
  #
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

  #
  # Don't daemonize for tests
  # Dont notify the terminal
  #
  c.before do
    Daemons.stub(daemonize: false)
    TerminalNotifier.stub(notify: true)
  end

  #
  # Cleanup .pom and .pomrc
  #

  [
    ["Pom::Config::CONFIG_PATH", File.expand_path('spec/.pom')],
    ["Pom::List::PATH",          File.expand_path('spec/.pomrc')]
  ].each do |tuple|
    path = tuple[1]

    c.before :each do
      stub_const(tuple[0], path)
      File.delete(path) if File.exists?(path)
    end

    c.after :each do
      File.delete(path) if File.exists?(path)
    end
  end
end
