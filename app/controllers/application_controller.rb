class ApplicationController < ActionController::Base
  protect_from_forgery
  @query = ""
  helper_method :flash_message
  before_filter :ip_ban

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
        ban = nil
      end
    end
    if ban != nil 
      cookies[:ip_banned] = { :value => request.remote_ip, :expires => 30.minutes.from_now }
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
end
