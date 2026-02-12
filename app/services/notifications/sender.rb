require 'sendgrid-ruby'

module Notifications
  class Sender
    include SendGrid

    def initialize(subject, message)
      @subject = subject
      @message = message
    end

    def call
      response = sendgrid.client.mail._('send').post(request_body: mail)
      response.status_code == '202'
    end

    private

    def sendgrid
      SendGrid::API.new(
        api_key: ENV.fetch('SENDGRID_API_KEY')
      )
    end

    def mail
      SendGrid::Mail.new(from, @subject, to, content).to_json
    end

    def from
      SendGrid::Email.new(
        email: ENV.fetch('SENDGRID_EMAIL_FROM'),
        name: 'Hippocrates'
      )
    end

    def to
      SendGrid::Email.new(
        email: ENV.fetch('SENDGRID_EMAIL_TO')
      )
    end

    def content
      SendGrid::Content.new(type: 'text/html', value: @message)
    end
  end
end
