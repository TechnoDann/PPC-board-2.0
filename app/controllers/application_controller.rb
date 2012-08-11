class ApplicationController < ActionController::Base
  protect_from_forgery
  @query = ""
  helper_method :flash_message

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

end
