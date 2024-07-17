class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers['token']&.split(' ')&.last
    decoded_token = JsonWebToken.decode(token)

    if decoded_token
      @current_user = User.find(decoded_token[:user_id])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
