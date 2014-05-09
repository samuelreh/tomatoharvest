require 'terminal-notifier' if TomatoHarvest::OS.mac?

module TomatoHarvest
  class Notifier
    class NotificationCenter
      def notify(message, opts = {})
        title = 'TomatoHarvest'

        TerminalNotifier.notify message, :title => title, :subtitle => opts[:subtitle]
      end
    end

  end
end
