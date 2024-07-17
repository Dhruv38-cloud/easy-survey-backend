require 'rails_helper'

RSpec.describe Survey, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'callbacks' do
    context 'after_initialize' do
      it 'sets default components to an empty array' do
        survey = Survey.new
        expect(survey.components).to eq([])
      end
    end
  end
end
