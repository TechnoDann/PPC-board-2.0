class UsersController < ApplicationController
  before_action :ip_ban
  before_action :authenticate_user!
  before_action :check_ban
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
