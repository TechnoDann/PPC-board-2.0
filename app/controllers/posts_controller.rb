class PostsController < ApplicationController
  before_filter :clear_return_url
  before_filter :authenticate_user_board!, :only => [:new, :create, :update, :edit, :preview]  
  before_filter :check_ban
  helper_method :allowed_to_edit?

  # GET /posts/search
  # GET /posts/search.json
  def search
    @query = params[:query] || false 
    @posts = Post.search @query, :match_mode => :extended, :page => params[:page]
    respond_to do |format|
      format.html
      format.json { render json: @posts }
      end
  end
  
  # GET /posts
  # GET /posts.json
  def index
    if params["sort_mode"]
      cookies.delete :sort_mode
      cookies[:sort_mode] = { :value => params[:sort_mode], :expires => 20.years.from_now }
    end
    cookies.delete :last_subforum

    @posts = Post.where(:ancestry => nil, :next_version_id => nil)
      .paginate(:page => params[:page]).order("sort_timestamp DESC")

#    @posts.each { |post| Post.where("ancestry LIKE '#{post.id}/%'").includes(:tags, :user).all }

    @tagged_posts = Hash.new do |hash, key|
      hash[key] = []
    end
    if cookies[:sort_mode] == "tag" || cookies[:sort_mode] == "subforum"
      @posts.each do |thread|
        if thread.tags.count == 0
          @tagged_posts[false] << thread #This takes care of "no tags at all"
        end
        tags = {}
        thread.subtree.each do |post|
          if post.tags.count > 0 
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

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
#    Post.where("ancestry LIKE '#{@post.id}/%'").includes(:tags, :user).all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post.subtree }
    end
  end

  # POST /posts/preview
  # PUT /posts/preview
  def preview
    @post = Post.new(params[:post], :as => (current_user.moderator? ? :moderator : :default))
    @post.user = current_user
    
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
      locked_post_reply = (parent_post.locked) || (parent_post.ancestors.where(:locked => true).count > 0)
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
        notify_watchers(@post)
        unless @post.ancestors.all.any? do |post|
            post.watchers.exists?(current_user.id)
          end
          @post.watchers = [current_user]
        end
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
      BoardMailer.notify_watchers(post, parent, user).deliver
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
end
