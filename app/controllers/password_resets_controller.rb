class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit,:update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  # GET /password_resets/new
  def new
  end
  
  #post /password_resetes = password_resets_path
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  #GET /password_resets/:id/edit

  def edit
    #@user = User.find_by(email: params[:email])
  end
  
  #post /password_resets/:id/
  
  def update
    if params[:user][:password].empty?                  # (3) への対応
      @user.errors.add(:password, :blank) #passwordがブランクなら
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応
    end
  end
  
  private
  
  def user_params #ストロングパラメータ
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  def valid_user
    if not (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
    end
  end
  
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
