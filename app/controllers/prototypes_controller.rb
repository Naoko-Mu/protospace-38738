class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototype = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)

    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end
  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  def edit
    @prototype = Prototype.find(params[:id])
    if current_user.id == @prototype.user.id
            render "edit"
          else
            redirect_to root_path
          end

  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)

    if @prototype.save
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  private

  def prototype_params
    params.require(:prototype).permit(:concept, :catch_copy, :title, :image).merge(user_id: current_user.id)
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
