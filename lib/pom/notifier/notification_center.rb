require 'terminal-notifier' if Pom::OS.mac?

module Pom
  class Notifier
    class NotificationCenter
      def notify(message, opts = {})
        title = 'Pom'

        TerminalNotifier.notify message, :title => title, :subtitle => opts[:subtitle]
      end
    end

  end
end
