class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorize

  def current_user
    @current_user ||= User.find(session[:user_id]) if session.key?(:user_id)
  end
  helper_method :current_user

  def authorize
    redirect_to(login_url, alert: "Please Login") if current_user.nil?
  end
end
