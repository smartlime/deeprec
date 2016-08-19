class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  private

  def load_commentable
    entity = request.path.split('/').second.singularize
    @commentable = entity.classify.constantize.find(params["#{entity}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body).merge({user_id: current_user.id})
  end
end
