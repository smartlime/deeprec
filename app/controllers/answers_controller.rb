class AnswersController < ApplicationController
  before_action :set_question_id

  def new
    @answer = Answer.new(question_id: @question_id)
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to question_path(@question_id)
    else
      render :new
    end
  end

  private

  def set_question_id
    @question_id = params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body).merge(question_id: @question_id)
  end
end
