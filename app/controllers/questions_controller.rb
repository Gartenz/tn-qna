class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question
  expose :answer, -> { question.answers.new }

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def create
    @exposed_question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question deleted successfully.'
    else
      render :show, alert: 'You can not delete not your own question'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
