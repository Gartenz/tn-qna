OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:vkontakte, {
  :provider => 'vkontakte',
  :uid => '123545',
  :info => {
    :email => nil
  }
})
OmniAuth.config.add_mock(:github, {
  :provider => 'github',
  :uid => '123545',
  :info => {
    :email => 'some_email@example.com'
  }
})
