require 'spec_helper'

describe 'Update subscriptions via API' do
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

    stub_request(:post, %r{\Ahttps://key\.api\.mailchimp\.com/2\.0/lists/}).
      to_return(body: '')
  end

  it 'can mark an email address as subscribed' do
    ChimpSync::Update.subscribed :test_list, 'pat@test.com', true

    expect(
      a_request(:post, 'https://key.api.mailchimp.com/2.0/lists/subscribe').
        with(body: "{\"apikey\":\"my-api-key\",\"id\":\"a6b5da1054\",\"email\":{\"email\":\"pat@test.com\"},\"double_optin\":false,\"send_welcome\":true}")
    ).to have_been_made
  end

  it 'can mark an email address as unsubscribed' do
    ChimpSync::Update.subscribed :test_list, 'pat@test.com', false

    expect(
      a_request(:post, 'https://key.api.mailchimp.com/2.0/lists/unsubscribe').
        with(body: "{\"apikey\":\"my-api-key\",\"id\":\"a6b5da1054\",\"email\":{\"email\":\"pat@test.com\"}}")
    ).to have_been_made
  end

  it 'can update an email address' do
    pending 'Need to identify the current email when sending through the new one'
    ChimpSync::Update.email :test_list, 'pat@test.com', 'pat+new@test.com'

    expect(a_request(
      :post, 'https://key.api.mailchimp.com/2.0/lists/update-member'
    ).with(
      body: "{\"apikey\":\"my-api-key\",\"id\":\"a6b5da1054\",\"email\":{\"email\":\"pat+new@test.com\"}}"
    )).to have_been_made
  end
end
