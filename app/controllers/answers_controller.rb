class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :star]
  before_action :check_owner!, only: [:update, :edit, :destroy]

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.
        merge({user_id: current_user.id})))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def edit
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def star
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

  def check_owner!
    return head :forbidden unless @answer.user_id == current_user.id
  end
end
