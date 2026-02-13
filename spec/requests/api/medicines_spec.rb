require 'rails_helper'

RSpec.describe 'API::Medicines', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/medicines' do
    let!(:medicines) { create_list(:medicine, 2) }

    before { get api_medicines_path(format: :json) }

    it 'formats the response as JSON' do
      json_response = JSON.parse(response.body)
      expect(json_response['suggestions']).to match_array(
        medicines.map do |m|
          hash_including('value' => m.name, 'data' => m.instructions)
        end
      )
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
