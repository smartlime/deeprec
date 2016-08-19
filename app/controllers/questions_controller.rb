class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :check_owner!, only: [:update, :edit, :destroy]

  respond_to :html, :js


  def index
    @questions = Question.all
    @question = Question.new
    @question.attachments.build
    respond_with @question, @questions
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    @question.save
    respond_with @question
  end

  def edit
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def check_owner!
    return head :forbidden unless @question.user_id == current_user.id
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:topic, :body,
                                     attachments_attributes: [:id, :file, :_destroy])
  end
end
