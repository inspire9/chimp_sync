require 'gibbon'
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
require 'chimp_sync/update'
