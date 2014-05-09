require_relative 'notifier/notification_center'

module TomatoHarvest
  class Notifier

    def initialize
      @notifier = TomatoHarvest::Notifier::NotificationCenter.new
    end

    def notify(message, opts = {})
      @notifier.notify(message, opts)
    end

  end
end
