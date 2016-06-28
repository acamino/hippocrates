require 'rails_helper'

describe ApplicationHelper do
  describe '#error_messages_for' do
    context 'when the resource contains errors' do
      it 'returns the error messages' do
        resource = double(:resource,
                          errors: double(:errors,
                                         any?: true,
                                         full_messages: {
                                           attribute: 'error message'
                                         }))
        expect(helper.error_messages_for(resource)).to include('error message')
      end
    end

    context 'when the resource does not contain errors' do
      it 'returns nil' do
        resource = double(:resource, errors: double(:errors, any?: false))
        expect(helper.error_messages_for(resource)).to be_nil
      end
    end
  end

  describe '#nav_to' do
    before do
      allow(helper).to receive(:params).and_return(controller: 'patients', action: 'special')
    end

    context 'when the nav_path includes the controller' do
      it 'builds an active nav_to' do
        expect(helper.nav_to('nav-text', '/patients/special')).to include('active')
      end
    end

    context 'when the nav_path does not include the controller' do
      it 'builds a nav_to without the active class' do
        expect(helper.nav_to('nav-text', '/medicines')).to_not include('active')
      end
    end
  end

  describe '#active_nav_to' do
    it 'builds an active nav_to' do
      expect(helper.active_nav_to('nav-text', '/patients/special')).to include('active')
    end
  end

  describe '#gender_tag' do
    context 'when the patient is male' do
      it 'builds a tag for male' do
        patient = double(:patient, male?: true)
        expect(helper.gender_tag(patient)).to include('fa-male')
      end
    end

    context 'when the patient is female' do
      it 'builds a tag for female' do
        patient = double(:patient, male?: false)
        expect(helper.gender_tag(patient)).to include('fa-female')
      end
    end
  end
end
