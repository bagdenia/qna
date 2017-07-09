require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :gon_user, unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: [exception.message] , :status => 500 }
      format.html { redirect_to root_url, :alert => exception.message }
      format.js   { render 'partials/exception', locals: {item: exception.message} }
    end
  end
  check_authorization unless: :devise_controller?

  def gon_user
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if current_user
  end
end
