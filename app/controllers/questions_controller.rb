class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find_by_id(params[:id])
    @answers = Answer.where(question: @question) # TODO: scoping with .eager_load im model (?)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.rating = 0

    if @question.save
      flash[:notice] = 'Вопрос был успешно размещен на сайте.'
      redirect_to @question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:topic, :body)
  end
end
