require_relative 'notifier/notification_center'

module Pom
  class Notifier

    def initialize
      @notifier = Pom::Notifier::NotificationCenter.new
    end

    def notify(message, opts = {})
      @notifier.notify(message, opts)
    end

  end
end
