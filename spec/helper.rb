$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'thor'
require 'tomatoharvest'

require 'webmock/rspec'
require 'minitest/unit'

require 'support/file_helpers'
require 'support/harvest_helpers'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.include MiniTest::Assertions
  c.include FileHelpers
  c.include HarvestHelpers

  #
  # Speed up the timer
  #
  c.before :each do
    const = 'TomatoHarvest::Timer::SLEEP_LENGTH'
    stub_const(const, 1/100000)
  end

  #
  # Stub HTTP requests
  #
  c.before do
    stub_harvest
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
