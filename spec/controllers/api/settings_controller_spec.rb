require 'rails_helper'

describe API::SettingsController do
  before { sign_in_user_mock }

  describe '#index' do
    before do
      Setting.create(name: 'name-1', value: 'value-1')
      Setting.create(name: 'name-2', value: 'value-2')

      get :index, format: :json
    end

    it 'formats the reponse as JSON' do
      diseases = ::JSON.parse(response.body)
      expect(diseases.last['value']).to eq('value-2')
    end

    it { is_expected.to respond_with :ok }
  end
end
