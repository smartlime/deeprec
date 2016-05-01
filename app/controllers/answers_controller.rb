class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to question_path(@question), notice: "Ответ успешно размещен."
    else
      render :new
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if answer.user_id == current_user.id
      answer.destroy!
      redirect_to answer.question, notice: "Ответ успешно удален."
    else
      redirect_to answer.question, alert: "Нельзя удалить чужой ответ."
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
