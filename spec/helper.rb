$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'thor'
require 'tomatoharvest'

require 'webmock/rspec'
require 'minitest/unit'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.include MiniTest::Assertions

  #
  # Speed up the timer
  #
  c.before :all do
    class TomatoHarvest::Timer
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
        name: 'Pomdoro',
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
    TomatoHarvest::Tmux.any_instance.stub(update: true)
  end

  #
  # Cleanup .toma and .tomaconfig
  #

  [
    ["TomatoHarvest::Config::GLOBAL_DIR", File.expand_path('spec/.toma/')],
    ["TomatoHarvest::Config::LOCAL_DIR",  File.expand_path('.toma/')]
  ].each do |const, path|
    c.before :each do
      stub_const(const, path)
      FileUtils.rm_rf(path) if File.directory?(path)
    end

    c.after :each do
      FileUtils.rm_rf(path) if File.directory?(path)
    end
  end
end
