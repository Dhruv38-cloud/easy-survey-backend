require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:surveys).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe 'instance methods' do
    let(:user) { create(:user) }

    describe '#generate_jwt' do
      it 'generates a valid JWT token' do
        token = user.generate_jwt
        decoded_token = JsonWebToken.decode(token)
        expect(decoded_token[:user_id]).to eq(user.id)
      end
    end
  end
end
