class Users::SessionsController < Devise::SessionsController
    layout 'registration'
    # before_filter :configure_sign_in_params, only: [:create]

    # def new
    #     super
    # end

    def create
      self.resource = User.find_by_email(params[:user][:email])
      if !resource.nil? && resource.email_confirmed
        self.resource = warden.authenticate!(auth_options)
        #set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)        
      elsif resource.nil?
        self.resource = warden.authenticate!(auth_options)
        #set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)                  
      else
        flash[:error] = t('pages.login.invalid_activate')
        respond_with resource, location: new_user_session_path
      end
    end
    
    # def destroy
    #     super
    # end

    # protected

    # # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #     devise_parameter_sanitizer.for(:sign_in) << :attribute
    # end
end
