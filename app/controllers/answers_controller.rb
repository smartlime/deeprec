class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :star]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer.update(answer_params) if @answer.user_id == current_user.id
  end

  def destroy
    @answer.destroy! if @answer.user_id == current_user.id
  end

  def star
    @answer.star!
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
