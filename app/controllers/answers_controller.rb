class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if @answer.user_id == current_user.id
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy! if @answer.user_id == current_user.id
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
