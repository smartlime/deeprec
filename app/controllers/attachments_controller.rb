class AttachmentsController < ApplicationController

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy! if @attachment.attachable.user_id == current_user.id
  end
end
