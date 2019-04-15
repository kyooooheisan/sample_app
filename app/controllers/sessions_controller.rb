class SessionsController < ApplicationController
  def new
    # @session = Session.new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user #helperで作成したメソッド
      #success
      redirect_to user
    else
      flash.now[:danger] = "invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  

end
