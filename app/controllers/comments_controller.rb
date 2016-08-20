class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :js

  def create
    # entity = params[:commentable].singularize
    # @commentable = entity.classify.constantize.find(params["#{entity}_id"])
    # @comment = @commentable.comments.build(params.require(:comment).permit(:body))
    # @comment.user_id = current_user.id
    # @comment.save
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  private

  def load_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge({user_id: current_user.id})
  end
end
