class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token,:activation_token,:reset_token
  before_save :downcase_email
  before_create :create_activation_email
  
  validates :name, presence: true, length: { maximum:50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum:255 },format:{with: VALID_EMAIL_REGEX},
             uniqueness: { case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum:6 },allow_nil: true
  
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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  #DBから消す
  def forget
    update_attribute(:remember_digest,nil)
  end
  
    # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    #selfはuserオブジェクト
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    #メールの有効期限を設定したいため、送った時間を記録しておくe
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  def feed
    Micropost.where("user_id = ?",self.id)
  end
  
  private
   
   def downcase_email
     self.email = self.email.downcase
   end
   
   def create_activation_email
     self.activation_token = User.new_token
     self.activation_digest = User.digest(self.activation_token)
     # この後にcreateが実行されるので、saveとかcreateのアクションが不要
   end
  
end