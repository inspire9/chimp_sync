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
require 'chimp_sync/subscriber'

ChimpSync::Subscriber.add :subscribe do |list, data|
  list.update_local.call data.email, true
end

ChimpSync::Subscriber.add :unsubscribe do |list, data|
  list.update_local.call data.email, false
end

ChimpSync::Subscriber.add :email_cleaned do |list, data|
  list.update_local.call data.email, false
end

ChimpSync::Subscriber.add :email_address_change do |list, data|
  list.update_local.call data.old_email, false
end
