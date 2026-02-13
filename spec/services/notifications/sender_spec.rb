require 'rails_helper'

RSpec.describe Notifications::Sender do
  let(:subject_line) { 'Test notification' }
  let(:message) { '<html><body><p>Test</p></body></html>' }

  subject(:sender) { described_class.new(subject_line, message) }

  before do
    ENV['SENDGRID_API_KEY'] = 'test-api-key'
    ENV['SENDGRID_EMAIL_FROM'] = 'from@example.com'
    ENV['SENDGRID_EMAIL_TO'] = 'to@example.com'
  end

  describe '#call' do
    let(:response) { instance_double('Response', status_code: '202') }
    let(:send_endpoint) { double('send', post: response) }
    let(:mail_endpoint) { double('mail', _: send_endpoint) }
    let(:client) { double('client', mail: mail_endpoint) }
    let(:api) { instance_double(SendGrid::API, client: client) }

    before do
      allow(SendGrid::API).to receive(:new).and_return(api)
    end

    it 'sends the email via SendGrid' do
      expect(send_endpoint).to receive(:post).with(request_body: kind_of(Hash))

      sender.call
    end

    it 'returns true when SendGrid responds with 202' do
      expect(sender.call).to be true
    end

    it 'returns false when SendGrid responds with an error' do
      allow(response).to receive(:status_code).and_return('400')

      expect(sender.call).to be false
    end

    it 'authenticates with the SENDGRID_API_KEY' do
      sender.call

      expect(SendGrid::API).to have_received(:new).with(api_key: 'test-api-key')
    end
  end
end
