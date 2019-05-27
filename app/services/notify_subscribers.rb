class Services::NotifySubscribers
  def send_emails(resource)
    resource.question.subscribers.each do |user|
      SubscriptionMailer.send_answer(resource, user).deliver_now
    end
  end
end
