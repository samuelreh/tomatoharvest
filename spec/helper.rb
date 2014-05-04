$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'thor'
require 'pom'

require 'minitest/unit'
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


  # TODO find a better way to stub Daemon
  c.before do
    Process.stub(daemon: true)
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
