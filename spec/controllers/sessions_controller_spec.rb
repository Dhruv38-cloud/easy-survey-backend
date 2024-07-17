require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token and user information' do
        post :create, params: { user: { email: user.email, password: 'password123' } }, format: :json
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('token')
        expect(json_response).to have_key('user')
        expect(json_response['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }, format: :json
        
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('error')
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end
end