class Api::V1::AnswersController < Api::V1::ApiController
  before_action :set_question

  def index
    respond_with @question.answers, include: nil
  end

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params)
    respond_with @answer
  end

  def show
    @answer = Answer.find(params[:id])
    authorize @answer
    respond_with @answer
  end

  private

  def set_question
    @question = Question.find(params[:question_id] || Answer.find(params[:id]).question_id)
    authorize @question, :show?
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end
end
