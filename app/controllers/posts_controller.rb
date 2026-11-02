class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Success!"
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post actualizado"
    else
      flash.now[:alert] = @post.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "The post is destroyed!"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    redirect_to posts_path, alert: "No puedes modificar este post" unless @post.user == current_user
  end

  def post_params
    params.expect(post: [:image, :description])
  end
end
