class Api::V1::QuestionsController < Api::V1::ApiController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    authorize @question
    respond_with @question
  end

  def create
    authorize Question
    @question = Question.create(question_params)
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:topic, :body).merge(user: current_user)
  end
end
