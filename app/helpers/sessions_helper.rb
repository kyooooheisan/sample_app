module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    #view側で使うからインスタンス変数
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
    #!のときは逆転するので、current_userがnilでなければtrueという意味
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
