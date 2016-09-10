class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show

  respond_to :js

  def index
    respond_with (@question = Question.new)
  end

  def show
    authorize @question
    respond_with @question
  end

  def new
    authorize Question
    respond_with(@question = Question.new)
  end

  def create
    authorize Question
    respond_with(@question = Question.create(question_params.merge({user_id: current_user.id})))
  end

  def update
    authorize @question
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    authorize @question
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:topic, :body,
                                     attachments_attributes: [:id, :file, :_destroy])
  end
end
