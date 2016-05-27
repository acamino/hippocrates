require 'rails_helper'

describe API::DiseasesController do
  describe '#index' do
    before do
      Disease.create(code: 'A001', name: 'sinusitis')
      Disease.create(code: 'A002', name: 'faringitis')

      get :index, format: :json
    end

    it { is_expected.to respond_with :ok }

    it "formats the reponse as JSON" do
      diseases = ::JSON.parse(response.body)
      expect(diseases.last['data']).to eq('A002')
    end
  end
end

