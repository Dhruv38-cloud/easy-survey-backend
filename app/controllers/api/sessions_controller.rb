class Api::SessionsController < Devise::SessionsController
  respond_to :json

  skip_before_action :authenticate_user!, :only => [:create]

  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully.', user: current_user }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Logged out successfully.' }, status: :ok
    else
      render json: { message: 'Failed to log out.' }, status: :unauthorized
    end
  end
end
