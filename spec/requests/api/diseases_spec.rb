require 'rails_helper'

RSpec.describe 'API::Diseases', type: :request do
  before { login_as create(:user), scope: :user }

  describe 'GET /api/diseases' do
    let!(:diseases) { create_list(:disease, 2) }

    before { get api_diseases_path(format: :json) }

    it 'formats the response as JSON' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include(
        'suggestions' => [
          hash_including(
            'value' => diseases.first.name,
            'data'  => diseases.first.code
          ),
          hash_including(
            'value' => diseases.last.name,
            'data'  => diseases.last.code
          )
        ]
      )
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
