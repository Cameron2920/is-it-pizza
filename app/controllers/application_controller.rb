class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :set_user
  before_action :set_show_login
  before_action :set_failed_login_redirect_url
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      request.referer
    end
  end

  def after_sign_out_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      request.referer
    end
  end

  private

  def set_user
    @current_user = current_user
  end

  def set_show_login
    @show_login = !devise_controller?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def set_failed_login_redirect_url
    @failed_login_redirect_url = controller_name + "#" + action_name
  end
end
