class WatchesController < ApplicationController
  before_filter :ip_ban
  before_filter :authenticate_user!
  before_filter :check_ban

  # POST /post/1/watch
  # POST /bans/1/watch.json
  def create
    @post = Post.find(params[:post_id])
    unless current_user.watched_posts.exists?(@post.id)
      current_user.watched_posts << @post
    end
    respond_to do |format|
      format.html { redirect_to @post, :flash => { :success => 'Thread was successfully watched.' } }
      format.json { head :no_content }
    end
  end

  # DELETE /posts/1/watch
  # DELETE /posts/1/watch.json
  def destroy
    @post = Post.find(params[:post_id])
    current_user.watched_posts.delete(@post)
    respond_to do |format|
      format.html { redirect_to @post, :flash => { :success => 'Thread was successfully unwatched.' } }
      format.json { head :no_content }
    end
  end
end
