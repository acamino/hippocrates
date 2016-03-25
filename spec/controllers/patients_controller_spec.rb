require 'rails_helper'

describe PatientsController do
  describe '#index' do
    before { get :index }

    it 'responds with ok' do
      expect(response).to be_ok
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
