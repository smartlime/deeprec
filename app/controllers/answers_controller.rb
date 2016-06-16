class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to question_path(@question), notice: 'Answer added.'
    else
      redirect_to question_path(@question), alert: 'Error adding answer.'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if answer.user_id == current_user.id
      answer.destroy!
      redirect_to answer.question, notice: 'Answer deleted.'
    else
      redirect_to answer.question, alert: 'Cannot delete other user\'s answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
