module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #セッションは消えているけど、クッキーには保存されている
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
    #!のときは逆転するので、current_userがnilでなければtrueという意味
  end
  
  #現在のユーザーをログアウト
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #ユーザーを永続的に復元できるようになった
  def remember(user)
    user.remember# => DB :remember_digestにsave
    cookies.permanent.signed[:user_id] = user.id#=>permanentを書けば、永続的に保存する
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
