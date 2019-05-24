# frozen_string_literal: true
class BansController < ApplicationController
  before_filter :ip_ban, :authenticate_user!, :check_ban, :except => [ :show ]
  before_filter :must_be_moderator!, :except => [ :show, :index ]

  # GET /bans
  # GET /bans.json
  def index
    @bans = Ban.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bans }
    end
  end

  # GET /bans/1
  # GET /bans/1.json
  def show
    @ban = Ban.find(params[:id])

    respond_to do |format|
      format.html { render :show, :status => :forbidden } # show.html.erb
      format.json { render json: @ban }
    end
  end

  # GET /bans/new
  # GET /bans/new.json
  def new
    @ban = Ban.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ban }
    end
  end

  # GET /bans/1/edit
  def edit
    @ban = Ban.find(params[:id])
  end

  # POST /bans
  # POST /bans.json
  def create
    @ban = Ban.new(ban_params)

    respond_to do |format|
      if @ban.save
        format.html { redirect_to root_path, notice: 'Ban was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @ban.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bans/1
  # PUT /bans/1.json
  def update
    @ban = Ban.find(params[:id])

    respond_to do |format|
      if @ban.update_attributes(ban_params)
        format.html { redirect_to root_path, notice: 'Ban was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ban.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bans/1
  # DELETE /bans/1.json
  def destroy
    @ban = Ban.find(params[:id])
    @ban.destroy

    respond_to do |format|
      format.html { redirect_to bans_url }
      format.json { head :no_content }
    end
  end

  private
  def ban_params
    params.require(:ban).permit(:email, :ip, :user_id, :length, :reason)
  end
end
