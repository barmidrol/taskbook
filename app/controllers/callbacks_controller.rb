class CallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :authenticate_user!
    
    def all
      p env["omniauth.auth"]
  		user = User.from_omniauth(env["omniauth.auth"], current_user)
      user.skip_confirmation!
  		if user.persisted?
        
  			flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
  			sign_in_and_redirect(user)
  		else
  			session["devise.user_attributes"] = user.attributes
  			redirect_to new_user_registration_url
  		end
    end

    def failure
      super
    end 

  alias_method :facebook, :all
	alias_method :twitter, :all
	alias_method :vkontakte, :all
end