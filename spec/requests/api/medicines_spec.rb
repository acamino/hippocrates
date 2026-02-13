require 'rails_helper'

RSpec.describe 'API::Medicines', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/medicines' do
    let!(:medicines) { create_list(:medicine, 2) }

    before { get api_medicines_path(format: :json) }

    it 'formats the response as JSON' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'suggestions' => [
          hash_including(
            'value' => medicines.first.name,
            'data'  => medicines.first.instructions
          ),
          hash_including(
            'value' => medicines.last.name,
            'data'  => medicines.last.instructions
          )
        ]
      )
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
