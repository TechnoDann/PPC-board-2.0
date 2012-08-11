class PostsController < ApplicationController
  before_filter :clear_return_url
  before_filter :authenticate_user_board!, :only => [:new, :create, :update, :edit]  

  helper_method :allowed_to_edit?
  # GET /posts/search
  # GET /posts/search.json
  def search
    @query = params[:query] || false 
    @tag_id = params[:tag_id] || false
    if @tag_id 
      @posts = Post.search :conditions => { :tags => Tag.find_by_id(@tag_id).name }
    else
      @posts = Post.search @query, :match_mode => :extended
    end
    respond_to do |format|
      format.html
      format.json { render json: @posts }
      end
  end
  
  # GET /posts
  # GET /posts.json
  def index
    if params["sort_by_tag"]
      cookies[:posts_by_tag] = { :value => (params[:sort_by_tag] == "1"),
        :expires => 20.years.from_now }
    end
    @posts = Post.includes(:user, :tags).where(:ancestry => nil, :next_version_id => nil)
      .paginate(:page => params[:page]).order("sort_timestamp DESC")
    
    @tagged_posts = Hash.new do |hash, key|
      hash[key] = []
    end
    if cookies[:posts_by_tag] == true 
      @posts.each do |post|
        if post.tags.count > 0 
          post.tags.each do |tag|
            @tagged_posts[tag.name] << post
          end
        else
          @tagged_posts[false] << post
        end
      end
    else
      @tagged_posts[false] = @posts
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new(:parent_id => params[:parent_id], :author => current_user.name)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if !allowed_to_edit? @post, current_user
      redirect_to posts_url, :flash => { :error => "You can\'t edit other people\'s posts." } 
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post], :as => (current_user.moderator? ? :moderator : :default))
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { flash[:success] = ['Post was successfully created.']
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
      redirect_to posts_url, :flash => { :error => "You can\'t edit other people\'s posts. Also, why are you bypassing access controls?" }
      logger.error("#{current_user.name} (#{current_user.id}) is trying to PUT #{@post.author}'s post (#{post.id}). CRACKER!")
    end
    @clone = @post.clone_before_edit
    @post.user = current_user
    respond_to do |format|
      if @post.update_attributes(params[:post], :as => (current_user.moderator? ? :moderator : :default))
        @post.close_edit_cycle @clone
        format.html { flash[:success] = ['Post was successfully updated.']
          redirect_to @post }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def allowed_to_edit?(post, user)
    return false if !user
    status = post.user == user || user.moderator?
    if !status && (post.previous_version_id != nil)
      status = allowed_to_edit? post.previous_version, user
    end
    status
  end

  private
  def clear_return_url
    session[:user_return_to] = nil
  end

  def authenticate_user_board!
    session[:user_return_to] = request.fullpath
    authenticate_user!
  end
end
