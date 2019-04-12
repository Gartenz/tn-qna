class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose :answer

  def create
    @exposed_answer = question.answers.new(answer_params)
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
