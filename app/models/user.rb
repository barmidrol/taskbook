class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, 
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :vkontakte]
  validates_presence_of :email
  has_many :authorizations
         
  def self.from_omniauth(auth, current_user)
    authorization = Authentication.where(:provider => auth.provider, :uid => auth.uid.to_s, 
                    :token => auth.credentials.token, :token_secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user =  User.where('email = ?', auth["info"]["email"]).first
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email.to_s
       if auth.provider == "twitter" 
         user.save(:validate => false) 
       else
         value = user.save
       end
     end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
   end
   authorization.user
 end

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

end
