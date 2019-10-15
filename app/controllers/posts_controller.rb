# frozen_string_literal: true
class PostsController < ApplicationController
  before_action :clear_return_url
  before_action :ip_ban, :authenticate_user_board!, :check_ban,
                :only => [:new, :create, :update, :edit, :preview, :destroy]
  before_action :must_be_moderator!, :only => [:destroy]
  helper_method :allowed_to_edit?

  # GET /posts/search
  # GET /posts/search.json
  def search
    @query = params[:query] || ""
    @posts = Post.text_search(@query).paginate(:page => params[:page])
             .with_pg_search_highlight.includes([:tags])
    respond_to do |format|
      format.html
      format.json { render json: @posts }
      end
  end

  # GET /posts
  # GET /posts.json
  def index
    if params[:sort_mode]
      cookies.delete :sort_mode
      cookies[:sort_mode] = { :value => params[:sort_mode], :expires => 20.years.from_now }
    end
    cookies.delete :last_subforum

    @posts = Post.where(:ancestry => nil, :next_version_id => nil)
      .paginate(:page => params[:page]).order("sort_timestamp DESC")

    @tagged_posts = Hash.new do |hash, key|
      hash[key] = []
    end
    if cookies[:sort_mode] == "tag" || cookies[:sort_mode] == "subforum"
      @posts.each do |thread|
        if not (thread.tags.any?)
          @tagged_posts[false] << thread #This takes care of "no tags at all"
        end
        tags = {}
        thread.subtree.each do |post|
          if post.tags.any?
            post.tags.each do |tag|
              tags[tag] = true
            end
          end
        end
        if tags.length > 0
          tags.each do |tag, truth|
            @tagged_posts[tag] << thread
          end
        end
      end
    else
      @tagged_posts[false] = @posts
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end

  # GET /posts/tagged/1
  # GET /posts/tagged/1.json
  def tagged
    cookies[:last_subforum] = { :value => params[:tag_id], :expires => 3.months.from_now }

    if params[:tag_id] == "nothing"
      @tag = false
      @raw_posts = Post.joins("LEFT JOIN posts_tags pt ON pt.post_id = posts.id")
        .where("pt.tag_id" => nil, "posts.next_version_id" => nil, "posts.ancestry" => nil)
        .paginate(:page => params[:page]).order("posts.sort_timestamp DESC")
      @posts = @raw_posts.map(&:root)
      @posts.uniq!
    else
      @tag = Tag.find(params[:tag_id])
      @raw_posts = @tag.posts.where(:next_version_id => nil)
        .paginate(:page => params[:page]).order("sort_timestamp DESC")
      @posts = @raw_posts.map(&:root)
      @posts.uniq!
    end

    respond_to do |format|
      format.html # tagged.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/scrape/2016/01{a,b}
  # GET /posts/scrape/2016/01{a,b}.json
  # GET /posts/scrape/2016/01?user_id=1
  # ...
  def scrape
    if cookies["foo"] != "bar" then
        return head :forbidden
    end
    @month_num = params[:month][0..-2].to_i(10)
    @month_side = params[:month][-1]
    @year = params[:year].to_i(10)
    date = DateTime.new(@year, @month_num)
    one_third = date.beginning_of_month + 10.days
    two_thirds = date.beginning_of_month + 20.days
    range =
      if @month_side == 'a' then
        date.beginning_of_month .. one_third
      elsif @month_side == 'b'
        one_third .. two_thirds
      elsif @month_side == 'c'
        two_thirds .. date.end_of_month
      else
        date.beginning_of_month .. date.end_of_month
      end
    conditions = {:ancestry => nil, :next_version_id => nil,
                  :sort_timestamp => range}
    if params[:user_id]
      conditions[:user_id] = params[:user_id].to_i(10)
    end
    @posts = Post.where(conditions).order("sort_timestamp ASC")

    status = if @posts.empty? then :not_found else :ok end
    respond_to do |format|
      format.html { render status: status }# scrape.html.erb
      format.json { render json: @posts, status: status }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { @post.body; render json: @post }
    end
  end

  # POST /posts/preview
  # PUT /posts/preview
  # PATCH /posts/preview
  def preview
    @post = Post.new(post_params)
    @post.user = current_user
    add_nm(@post)

    respond_to do |format|
      format.html { render :partial => 'post', :object => @post, :locals => { :hide_status_info => true } }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new(:parent_id => params[:parent_id], :author => current_user.name,
                     :tag_ids => [params[:tag_id]])
    locked_post_reply = false
    if params[:parent_id]
      parent_post = Post.find(params[:parent_id])
      locked_post_reply = (parent_post.locked) || (parent_post.ancestors.where(:locked => true).any?)
    end

    respond_to do |format|
      format.html { flash[:warning] = "You're trying to reply to a locked post, which is not allowed" if locked_post_reply } # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if !allowed_to_edit? @post, current_user
      redirect_to posts_url, :flash => { :error => "You can't edit other people's posts." } 
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    adding_watch = (@post.watch_add == "1")
    @post.user = current_user
    add_nm(@post)

    respond_to do |format|
      if @post.save
        notify_watchers(@post)
        if adding_watch
          @post.watchers << current_user
        end
        # Restore to auto-subscribe people to things they post
        # unless @post.ancestors.all.any? do |post|
        #     post.watchers.exists?(current_user.id)
        #   end
        #   @post.watchers = [current_user]
        # end
        format.html { flash[:success] = ["Post was successfully created."]
          redirect_to @post }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    if !allowed_to_edit? @post, current_user
      redirect_to posts_url, :flash => { :error => "You can't edit other people's posts. Also, why are you bypassing access controls?" }
      logger.error("#{current_user.name} (#{current_user.id}) is trying to PUT #{@post.author}'s post (#{post.id}). CRACKER!")
    end
    @clone = @post.clone_before_edit
    @post.user = current_user
    respond_to do |format|
      if @post.update_attributes(post_params)
        @post.close_edit_cycle @clone
        format.html { flash[:success] = ["Post was successfully updated."]
          redirect_to @post }
        format.json { head :no_content }
      else
        @clone.destroy
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    unless user_signed_in? && current_user.moderator?
      redirect_to posts_url, :flash => { :error => "You can't delete posts unless you're a moderator" }
      logger.error("#{current_user.name} (#{current_user.id}) is trying to DELETE #{@post.author}'s post (#{post.id}). CRACKER!")
    end

    respond_to do |format|
      if @post.destroy
        format.html { flash[:success] = ["Post successfully deleted."]
          redirect_to(root_path) }
        format.json { head :no_content }
      else
        format.html { render action: "show", flash: {error: "Failed to delete post" } }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def allowed_to_edit?(post, user)
    return false if !user
    status = post.user_id == user.id || user.moderator?
    if !status && (post.previous_version_id != nil)
      status = allowed_to_edit? post.previous_version, user
    end
    status
  end

  def notify_watchers(post)
    users_to_notify = Hash.new
    post.ancestors.each do |parent|
      parent.watchers.each do |user|
        unless user == post.user
          users_to_notify[user] = parent
        end
      end
    end
    users_to_notify.each do |user, parent|
      BoardMailer.notify_watchers(post, parent, user).deliver_now
    end
  end

  private
  def clear_return_url
    session[:user_return_to] = nil
  end

  def authenticate_user_board!
    session[:user_return_to] = request.fullpath
    authenticate_user!
  end

  def add_nm(post)
    if @post.body == ""
      @post.subject += " (nm)"
    end
  end

  def post_params
    if current_user.moderator?
      params.require(:post).permit(:locked, :poofed, :override_sort_timestamp, :sort_timestamp, :body, :subject, :author, :parent_id, :watch_add, :tag_ids => [])
    else
      params.require(:post).permit(:body, :subject, :author, :parent_id, :watch_add, :tag_ids => [])
    end
  end
end
