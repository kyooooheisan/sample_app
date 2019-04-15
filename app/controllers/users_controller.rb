class UsersController < ApplicationController
  
  
  def show
    @user = User.find(params[:id])
    # debugger
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "welcome to the sample app"
      # success
      # redirect_to user_path(@user.id)
      # redirect_to user_path(@user)
      redirect_to @user
      # => GET "/users/#{@user.id}" => show
    else
      render 'new'
    end
  end
  
  def user_params
    params.require(:user).permit(:name, :email,:password,:password_confirmation)
  end
  
end
