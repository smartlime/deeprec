class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    entity = params[:commentable].singularize
    @commentable = entity.classify.constantize.find(params["#{entity}_id"])
    @comment = @commentable.comments.build(params.require(:comment).permit(:body))
    @comment.user_id = current_user.id
    @comment.save
  end
end
