# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :devise_permitted_parameters, if: :devise_controller?
  @query = ""
  helper_method :flash_message

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def ip_ban
    ban = Ban.find_ban(:ip => request.remote_ip)
    if cookies[:ip_banned] != nil
      stored_ban = Ban.find_ban(:ip => cookies[:ip_banned])
      if stored_ban
        ban = stored_ban
      else
        cookies.delete :ip_banned
      end
    end
    if ban != nil
      cookies[:ip_banned] = { :value => request.remote_ip, :expires => 2.months.from_now }
      redirect_to(ban)
    end
  end

  def check_ban
    if user_signed_in?
      ban = Ban.find_ban(:user_id => current_user.id)
      if  ban
        sign_out current_user
        redirect_to ban_path(ban)
      end
    end
  end

  def must_be_moderator!
    unless user_signed_in? && current_user.moderator?
      redirect_to root_path, :flash => { :error => "You must be a moderator to perform this action." },
          :status => :forbidden
    end
  end

  protected

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :antispam])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end
end
