class ChimpSync::Subscriber
  def self.add(type, &block)
    ActiveSupport::Notifications.subscribe("#{type}.panthoot") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      data  = event.payload[type]

      ChimpSync.lists_for(data.list_id).each do |list|
        block.call list, data
      end
    end
  end
end
