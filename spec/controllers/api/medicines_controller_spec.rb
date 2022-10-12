require 'rails_helper'

describe API::MedicinesController do
  before { sign_in_user_mock }

  describe '#index' do
    let!(:medicines) { create_list(:medicine, 2) }

    before { get :index, format: :json }

    it 'formats the reponse as JSON' do
      json_response = ::JSON.parse(response.body)
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

    it { is_expected.to respond_with :ok }
  end
end
