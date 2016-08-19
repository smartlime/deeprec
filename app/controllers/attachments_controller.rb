class AttachmentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_atachment
  before_filter :check_owner!

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_atachment
    @attachment = Attachment.find(params[:id])
  end

  def check_owner!
    return head :forbidden unless @attachment.attachable.user_id == current_user.id
  end
end
