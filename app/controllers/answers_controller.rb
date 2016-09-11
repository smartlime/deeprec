class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :star]

  respond_to :js

  def create
    authorize Answer
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.
        merge({user_id: current_user.id})))
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    respond_with @answer
  end

  def edit
    authorize @answer
  end

  def destroy
    authorize @answer
    respond_with(@answer.destroy)
  end

  def star
    authorize @answer
    respond_with(@answer.star!)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
        attachments_attributes: [:file])
  end
end
