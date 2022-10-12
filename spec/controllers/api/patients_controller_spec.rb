require 'rails_helper'

describe API::PatientsController do
  before { sign_in_user_mock }

  describe '#index' do
    context 'when there are patients who match the criteria' do
      let!(:alan) { create(:patient, last_name: 'Doe') }
      let!(:marc) { create(:patient, last_name: 'Doe') }

      before do
        get :index, format: :json, params: { query: 'Doe' }
      end

      it 'formats the reponse as JSON' do
        json_response = ::JSON.parse(response.body)
        expect(json_response).to include(
          'suggestions' => [
            hash_including(
              'data'  => alan.id,
              'value' => alan.full_name
            ),
            hash_including(
              'data'  => marc.id,
              'value' => marc.full_name
            )
          ]
        )
      end

      it { is_expected.to respond_with :ok }
    end

    context 'when there are *NO* patients who match the criteria' do
      before do
        create_list(:patient, 2, last_name: 'Doe')
        get :index, format: :json, params: { query: 'Ada' }
      end

      it 'formats the reponse as JSON' do
        json_response = ::JSON.parse(response.body)
        expect(json_response).to include(
          'suggestions' => []
        )
      end

      it { is_expected.to respond_with :ok }
    end
  end
end
