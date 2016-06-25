require 'rails_helper'

describe API::MedicinesController do
  before { sign_in_user_mock }

  describe '#index' do
    before do
      create_list(:medicine, 2)
      get :index, format: :json
    end

    it 'formats the reponse as JSON' do
      medicines = ::JSON.parse(response.body)
      expect(medicines.count).to eq(2)
    end

    it { is_expected.to respond_with :ok }
  end
end
