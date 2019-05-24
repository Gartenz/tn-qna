class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params['id'])
    if @question
      render json: @question
    else
      head :not_found
    end
  end

  def create
    question = current_resource_onwer.questions.new(question_params)
    if question.save
      render json: question
    else
      head :bad_request
    end

  rescue ActionController::ParameterMissing
    head :bad_request
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
