class Users::PasswordsController < Devise::PasswordsController
  layout 'registration'
  # GET /resource/password/new
   def new
     super
   end

  # POST /resource/password
   def create
    super

    raw, enc = Devise.token_generator.generate(resource.class, :reset_password_token)

    resource.reset_password_token   = enc
    resource.reset_password_sent_at = Time.now.utc
    resource.save(validate: false)

    reset_url = Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: raw)
    reset_url = "#{request.protocol}#{request.host_with_port}#{reset_url}"
    template = t('mailers.mail_reset_password.content', name: resource.name, url: reset_url).html_safe
    RegistrationMailer.reset_password_confirmation(resource, template).deliver_now
   end

  # GET /resource/password/edit?reset_password_token=abcdef
   def edit
     super
   end

  # PUT /resource/password
   def update
     super
   end

  # protected

   def after_resetting_password_path_for(resource)
     super(resource)
   end

  # The path used after sending reset password instructions
   def after_sending_reset_password_instructions_path_for(resource_name)
     super(resource_name)
   end
end
