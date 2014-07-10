class ChimpSync::Update
  def self.subscribed(label, email, subscribed)
    list   = ChimpSync.lists[label]
    gibbon = Gibbon::API.new list.api_key

    if subscribed
      gibbon.lists.subscribe id: list.id, email: {email: email},
        double_optin: false, send_welcome: true
    else
      gibbon.lists.unsubscribe id: list.id, email: {email: email}
    end
  end

  def self.email(label, old_email, new_email)
    raise 'Not yet implemented.'
    list   = ChimpSync.lists[label]
    gibbon = Gibbon::API.new list.api_key

    gibbon.lists.update_member id: list.id, email: {email: new_email}
  end
end
