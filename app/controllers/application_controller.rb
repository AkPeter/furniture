class ApplicationController < ActionController::Base
  SignInURL = 'http://telegus.ru'
  Domain = 'telegus.ru'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:uid]&&User.any?
      users = User.where(id: session[:uid])
      users.any? ? users.first : nil
    end
  end
  helper_method :current_user

end