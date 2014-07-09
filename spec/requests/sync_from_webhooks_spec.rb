require 'spec_helper'

describe 'Sync from Webhooks', type: :request do
  let(:list_id) { 'a6b5da1054' }
  let(:email)   { 'pat@test.com' }

  before :each do
    ChimpSync.reset
    ChimpSync.sync :test_list do |list|
      list.api_key = 'my-api-key'
      list.id      = list_id

      list.update_local = lambda { |email, subscribed|
        User.find_by(email: email).update_attributes(subscribed: subscribed)
      }
    end
  end

  it 'marks users as subscribed when MailChimp sends a subscribe hook' do
    user = User.create! email: email, subscribed: false

    post '/panthoot/hooks', 'type' => 'subscribe',
      'fired_at' => Time.zone.now.to_s(:db), 'data[id]' => '8a25ff1d98',
      'data[list_id]' => list_id, 'data[email]' => email,
      'data[email_type]' => 'html', 'data[merges][EMAIL]' => 'email',
      'data[merges][FNAME]' => 'MailChimp', 'data[merges][LNAME]' => 'API',
      'data[ip_opt]' => '10.20.10.30', 'data[ip_signup]' => '10.20.10.30'

    expect(user.reload).to be_subscribed
  end

  it 'marks users as unsubscribed when MailChimp sends an unsubscribe hook' do
    user = User.create! email: email, subscribed: true

    post '/panthoot/hooks', 'type' => 'unsubscribe',
      'fired_at' => Time.zone.now.to_s(:db), 'data[id]' => '8a25ff1d98',
      'data[list_id]' => list_id, 'data[email]' => email,
      'data[email_type]' => 'html', 'data[merges][EMAIL]' => 'email',
      'data[merges][FNAME]' => 'MailChimp', 'data[merges][LNAME]' => 'API',
      'data[ip_opt]' => '10.20.10.30', 'data[ip_signup]' => '10.20.10.30'

    expect(user.reload).to_not be_subscribed
  end

  it 'marks users as unsubscribed when MailChimp sends a clean hook' do
    user = User.create! email: email, subscribed: true

    post '/panthoot/hooks', 'type' => 'cleaned',
      'fired_at' => Time.zone.now.to_s(:db), 'data[list_id]' => list_id,
      'data[campaign_id]' => '4fjk2ma9xd', 'data[reason]' => 'hard',
      'data[email]' => email

    expect(user.reload).to_not be_subscribed
  end

  it 'marks users as unsubscribed when MailChimp sends a change hook' do
    user = User.create! email: email, subscribed: true

    post '/panthoot/hooks', 'type' => 'upemail',
      'fired_at' => Time.zone.now.to_s(:db), 'data[list_id]' => list_id,
      'data[new_id]' => '51da8c3259',
      'data[new_email]' => 'api+new@mailchimp.com', 'data[old_email]' => email

    expect(user.reload).to_not be_subscribed
  end
end
