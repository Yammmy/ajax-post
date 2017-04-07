class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def index
    @posts = Post.all
    @posts = Post.order("id DESC").limit(20)

    if params[:max_id]
      @posts = @posts.where( "id < ?", params[:max_id])
    end

    respond_to do |format|
      format.html  # 如果客户端要求 HTML，则回传 index.html.erb
      format.js    # 如果客户端要求 JavaScript，回传 index.js.erb
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

    # redirect_to posts_path
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    # render :js => "alert('ok');"
    render :json => { :id => @post.id }
  end

  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)
      Like.create!(:user => current_user, :post => @post)
    end
    # redirect_to posts_path
  end

  def unlike
    @post  = Post.find(params[:id])
    like = @post.find_lke(current_user)
    like.destroy
    # redirect_to posts_path
  end

  def toggle_flag
    @post = Post.find(params[:id])

    if @post.flag_at
      @post.flag_at = nil
    else
      @post.flag_at = Time.now
    end

    @post.save!

    render :json => { :message => "ok", :flag_at => @post.flag_at }
  end

  protected

  def post_params
    params.require(:post).permit(:content)
  end
end
