class PagesController < ApplicationController
  skip_before_action :ip_ban, :check_ban, :only => [:data_collection]
  def formatting_help
    respond_to do |format|
      format.html
    end
  end

  def data_collection
    respond_to do |format|
      format.html
    end
  end
end
