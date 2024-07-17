require 'rails_helper'

RSpec.describe Api::SurveysController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:valid_attributes) { attributes_for(:survey) }
  let(:invalid_attributes) { attributes_for(:survey, name: nil) }

  before do
    request.headers['token'] = token
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new survey' do
        expect {
          post :create, params: { survey: valid_attributes }, format: :json
        }.to change(Survey, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { survey: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'returns an unprocessable entity status' do
        post :create, params: { survey: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #show' do
    let(:survey) { create(:survey, user: user) }

    it 'returns the survey' do
      get :show, params: { id: survey.id }, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
    let(:survey) { create(:survey, user: user) }

    context 'with valid attributes' do
      let(:new_attributes) { { name: 'Updated Survey' } }

      it 'updates the survey' do
        put :update, params: { id: survey.id, survey: new_attributes }, format: :json
        survey.reload
        expect(survey.name).to eq('Updated Survey')
      end

      it 'returns a success status' do
        put :update, params: { id: survey.id, survey: new_attributes }, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'returns an unprocessable entity status' do
        put :update, params: { id: survey.id, survey: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
