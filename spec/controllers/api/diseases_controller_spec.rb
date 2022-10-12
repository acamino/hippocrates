require 'rails_helper'

describe API::DiseasesController do
  before { sign_in_user_mock }

  describe '#index' do
    let!(:diseases) { create_list(:disease, 2) }

    before { get :index, format: :json }

    it 'formats the reponse as JSON' do
      json_response = ::JSON.parse(response.body)
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

    it { is_expected.to respond_with :ok }
  end
end
