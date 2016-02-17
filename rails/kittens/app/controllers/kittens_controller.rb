class KittensController < ApplicationController

  def new
    @kitten = Kitten.new
  end

  def create
    @kitten = Kitten.create(kitten_params)
    if @kitten.save
      flash[:success] = "You have registered your kitten!"
      redirect_to @kitten
    else
      flash.now[:danger] = "Try that again. Your kitten needs a name."
      render 'new'
    end
  end

  def edit
    @kitten = Kitten.find_by(id: params[:id])
  end

  def update
    @kitten = Kitten.find_by(id: params[:id])
    if @kitten.update_attributes name: kitten_params[:name], age: kitten_params[:age], cuteness: kitten_params[:cuteness], softness: kitten_params[:softness]
      flash.now[:success] = "You have updated your kitten!"
      render :show
    else
      flash.now[:danger] = "Try that again. Your kitten needs a name."
      render :edit
    end
  end

  def show
    @kitten = Kitten.find_by(id: params[:id])
    respond_to do |format|
      format.html # defaults to index.html.erb
      format.xml { render :xml => @kitten }
      format.json { render :json => @kitten }
    end
  end

  def index
    @kittens = Kitten.all
    respond_to do |format|
      format.html # defaults to index.html.erb
      format.xml { render :xml => @kittens }
      format.json { render :json => @kittens }
    end
  end

  def destroy
    @kitten = Kitten.find_by(id: params[:id])
    @kitten.destroy
    flash[:danger] = "YOU MONSTER!"
    redirect_to root_path
  end

  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness)
  end

end
