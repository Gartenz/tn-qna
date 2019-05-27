class SubscribersNotifyJob < ApplicationJob
  queue_as :default

  def perform(resource)
    Services::NotifySubscribers.new.send_emails(resource)
  end
end
