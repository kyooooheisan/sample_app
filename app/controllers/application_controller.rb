class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def hello
    render html:"Hello,world"
  end
  
  private
  
      #ログイン済みユーザーかを確認
    def logged_in_user
      # unless = if not
      unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
      end
    end
end
