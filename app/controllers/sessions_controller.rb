class SessionsController < ApplicationController
  def new
    # @session = Session.new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      #success
      log_in user #helperで作成したメソッド
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    #ログインしている？かを確認する
    log_out if logged_in?
    redirect_to root_url
  end
  

end
