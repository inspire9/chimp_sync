# ChimpSync

ChimpSync keeps MailChimp list subscription details synced with your own data.

## Installation

Add the gem to your application's Gemfile:

```ruby
gem 'chimp_sync', '~> 0.0.1'
```

This gem uses Panthoot for receiving MailChimp webhooks. If you're using Rails, the endpoint is automatically connected to `/panthoot/hooks`. If you're not using Rails, then you'll want to mount `Panthoot::App.new` into your app somewhere.

## Usage

In an initializer or similar, to ensure any changes made from MailChimp's side of things are reflected in your app:

```ruby
# Repeat as needed for as many lists as required - the label argument must be
# unique for each, though.
ChimpSync.sync :my_label do |list|
  list.api_key = ENV['MAILCHIMP_API_KEY']
  list.id      = ENV['MAILCHIMP_LIST_ID']

  list.update_local = lambda { |email, subscribed|
    # email is the email address as a string, subscribed is a boolean
    # indicating the new subscription status via MailChimp.
    User.find_by(email: email).update_attributes(subscribed: subscribed)
  }
end
```

You'll also want to pass back local changes to MailChimp:

```ruby
ChimpSync.update :my_label, user.email, user.subscribed
```

## Contributing

1. Fork it ( https://github.com/inspire9/chimp_sync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

Copyright (c) 2014, ChimpSync is developed and maintained by Pat Allan and "Inspire9":http://inspire9.com, and is released under the open MIT Licence.
