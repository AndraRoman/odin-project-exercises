class KittensController < ApplicationController

  def new
    @kitten = Kitten.new
  end

  def create
    @kitten = Kitten.create(kitten_params)
    # TODO
  end

  def edit
    @kitten = Kitten.find_by(id: params[:id])
  end

  def update
    # TODO
  end

  def show
    @kitten = Kitten.find_by(id: params[:id])
  end

  def index
    @kittens = Kitten.all
  end

  def destroy
    # TODO
  end

  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness)
  end

end
