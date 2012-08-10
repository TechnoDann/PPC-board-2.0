class PostsController < ApplicationController
  
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
    @posts = Post.where(:ancestry => nil, :next_version_id => nil)
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
    @post = Post.new(:parent_id => params[:parent_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post], :as => :moderator)
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
    @clone = @post.clone_before_edit
    respond_to do |format|
      if @post.update_attributes(params[:post], :as => :moderator)
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

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to posts_url, :flash => { :error => "Posts can't be deleted." } }
      format.json { head :no_content }
    end
  end
end
