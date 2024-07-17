class Api::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session
  respond_to :json

  skip_before_action :authenticate_user!

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        # token = resource.generate_jwt
        render json: { user: resource }, status: :created
      else
        expire_data_after_sign_in!
        render json: { message: "Signed up but #{resource.inactive_message}" }, status: :ok
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end
end
