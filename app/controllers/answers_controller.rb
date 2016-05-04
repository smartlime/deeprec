class AnswersController < ApplicationController
  before_action :get_question_id

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to question_path(@question_id)
    else
      redirect_to question_path(@question_id)
    end
  end

  private

  def get_question_id
    @question_id = params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body).merge(question_id: @question_id)
  end
end
