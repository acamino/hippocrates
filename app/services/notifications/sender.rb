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
        api_key: Rails.application.secrets.sendgrid.fetch(:api_key)
      )
    end

    def mail
      SendGrid::Mail.new(from, @subject, to, content).to_json
    end

    def from
      SendGrid::Email.new(
        email: Rails.application.secrets.sendgrid.fetch(:email_from),
        name: 'Hippocrates'
      )
    end

    def to
      SendGrid::Email.new(
        email: Rails.application.secrets.sendgrid.fetch(:email_to)
      )
    end

    def content
      SendGrid::Content.new(type: 'text/html', value: @message)
    end
  end
end
