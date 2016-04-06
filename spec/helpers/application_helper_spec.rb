require 'rails_helper'

describe ApplicationHelper do
  describe '#error_messages_for' do
    context 'when the resource contains errors' do
      it 'returns the error messages' do
        resource = double(:resource,
                          errors: double(:errors, any?: true, full_messages: { attribute: 'error message' }))
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
end
