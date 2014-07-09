require 'panthoot'

module ChimpSync
  def self.lists_for(list_id)
    lists.values.select { |list| list.id == list_id }
  end

  def self.lists
    @lists ||= {}
  end

  def self.reset
    @lists = {}
  end

  def self.sync(label, &block)
    lists[label] = ChimpSync::List.new.tap { |list| block.call list }
  end
end

require 'chimp_sync/list'

ActiveSupport::Notifications.subscribe('subscribe.panthoot') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  data  = event.payload[:subscribe]

  ChimpSync.lists_for(data.list_id).each do |list|
    list.update_local.call data.email, true
  end
end

ActiveSupport::Notifications.subscribe('unsubscribe.panthoot') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  data  = event.payload[:unsubscribe]

  ChimpSync.lists_for(data.list_id).each do |list|
    list.update_local.call data.email, false
  end
end

ActiveSupport::Notifications.subscribe('email_cleaned.panthoot') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  data  = event.payload[:email_cleaned]

  ChimpSync.lists_for(data.list_id).each do |list|
    list.update_local.call data.email, false
  end
end

ActiveSupport::Notifications.subscribe('email_address_change.panthoot') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  data  = event.payload[:email_address_change]

  ChimpSync.lists_for(data.list_id).each do |list|
    list.update_local.call data.old_email, false
  end
end
