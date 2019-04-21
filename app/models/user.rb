class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum:50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum:255 },format:{with: VALID_EMAIL_REGEX},
             uniqueness: { case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum:6 }
  
  # 渡された文字列のハッシュ値をかえす
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  #
  def remember
    #インスタンスメソッドだから使える
    #selfをつけないとローカル変数になる
    self.remember_token = User.new_token
    #ユーザーが入力することがないから、バリデーションが不要
    self.update_attribute(:remember_digest,User.digest(remember_token))
  end

#渡されたトークンが、ダイジェストと一致したらtrueを返す

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #DBから消す
  def forget
    update_attribute(:remember_digest,nil)
  end
  
end