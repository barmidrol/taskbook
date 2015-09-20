class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name)
  end

end