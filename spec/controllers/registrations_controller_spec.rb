require 'rails_helper'

RSpec.describe Api::RegistrationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        email: 'test@gmail.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    let(:invalid_attributes) do
      {
        email: 'test1@gmail.com',
        password: 'password',
        password_confirmation: 'mismatch'
      }
    end

    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_attributes }, format: :json
        }.to change(User, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { user: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'returns the created user' do
        post :create, params: { user: valid_attributes }, format: :json
        expect(JSON.parse(response.body)['user']['email']).to eq('test@gmail.com')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_attributes }, format: :json
        }.not_to change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { user: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the errors' do
        post :create, params: { user: invalid_attributes }, format: :json
        expect(JSON.parse(response.body)).to eq({ 'password_confirmation' => ["doesn't match Password"] })
      end
    end
  end
end
