class Api::V1::QuestionsController < Api::V1::BaseController
  expose(:question) { params['id'] ? Question.find(params['id']) : Quesiton.new }

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    if question
      render json: question
    else
      head :not_found
    end
  end

  def create
    question = current_resource_onwer.questions.new(question_params)
    if question.save
      render json: question, location: api_v1_question_url(question)
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def update
    if question.update(question_params)
      render json: question, location: api_v1_question_url(question)
    else
      head :bad_request
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def destroy
    question.destroy
    head :ok
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
