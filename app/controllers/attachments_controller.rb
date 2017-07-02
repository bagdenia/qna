class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_file
  respond_to :js

  def show
  end

  def destroy
    if current_user.id == @attachment.attachmentable.user_id
      respond_with(@attachment.destroy)
    end
  end

  private

  def load_file
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end

