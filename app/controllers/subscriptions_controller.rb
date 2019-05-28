class SubscriptionsController < ApplicationController
  def create
    question = Question.find(params['question_id'])
    if !question.subscribed?(current_user)
      question.subscribe(current_user)
      render template: "subscriptions/subscribe", locals: { resource: question }
    end
  end

  def destroy
    subscription = Subscription.find(params['id'])
    subscription.delete
    render template: "subscriptions/subscribe", locals: { resource: subscription.subscribable }
  end
end
