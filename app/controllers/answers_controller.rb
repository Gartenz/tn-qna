class AnswersController < ApplicationController
  expose :question
  expose :answer

  def create
    asnwer = question.answers.new(answer_params)
    if asnwer.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
