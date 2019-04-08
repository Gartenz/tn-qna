class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  expose :question
  expose :answer

  def create
    asnwer = question.answers.new(answer_params)
    if asnwer.save
      redirect_to question_path(question), notice: 'Answer was added successfully.'
    else
      errors = asnwer.errors.full_messages.join('|')
      redirect_to question_path(question), notice: errors
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
