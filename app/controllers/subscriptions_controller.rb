class SubscriptionsController < ApplicationController
  expose(:question)

  def create
    @exposed_question = Question.find(params['question_id'])
    if !question.subscribed?(current_user)
      question.subscribe(current_user)
      render :subscribe
    end
  end

  def destroy
    subscription = Subscription.find(params['id'])
    subscription.delete
    @exposed_question = subscription.subscribable
    render :subscribe
  end
end
