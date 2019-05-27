class SubscriptionMailer < ApplicationMailer
  def send_answer(answer, user)
    @answer = answer
    mail to: user.email
  end
end
