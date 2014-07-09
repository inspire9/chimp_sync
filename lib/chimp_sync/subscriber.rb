class ChimpSync::Subscriber
  def self.add(*types, &block)
    types.each do |type|
      ActiveSupport::Notifications.subscribe("#{type}.panthoot") do |*args|
        new(type, &block).call *args
      end
    end
  end

  def initialize(type, &block)
    @type, @block = type, block
  end

  def call(*arguments)
    data = ActiveSupport::Notifications::Event.new(*arguments).payload[type]

    ChimpSync.lists_for(data.list_id).each do |list|
      block.call list, data
    end
  end

  private

  attr_reader :type, :block
end

ChimpSync::Subscriber.add :subscribe do |list, data|
  list.update_local.call data.email, true
end

ChimpSync::Subscriber.add :unsubscribe, :email_cleaned do |list, data|
  list.update_local.call data.email, false
end

ChimpSync::Subscriber.add :email_address_change do |list, data|
  list.update_local.call data.old_email, false
end
