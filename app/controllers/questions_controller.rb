class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :get_new_answer, only: %i[show]

  expose :questions, -> { Question.all }
  expose :question

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def create
    @exposed_question = current_user.created_questions.new(question_params)
    if @exposed_question.save
      redirect_to @exposed_question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question deleted successfully.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def get_new_answer
    @answer = session[:error_obj] ? session[:error_obj] : question.answers.new
    session[:error_obj] = nil
  end
end
