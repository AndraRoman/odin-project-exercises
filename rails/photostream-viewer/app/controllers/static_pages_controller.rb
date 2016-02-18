class StaticPagesController < ApplicationController

  def show
    @user_id = params[:user_id] || "" 
  end

  private

  def home_params
    params.require(:user_id)
  end

end
