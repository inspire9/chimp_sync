ActiveRecord::Schema.define do
  create_table :users, force: true do |table|
    table.string  :email,      null: false
    table.boolean :subscribed, null: false
  end
end
