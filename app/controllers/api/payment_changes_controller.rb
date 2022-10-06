module API
  class PaymentChangesController < BaseController
    before_action :fetch_consultation

    def index
      payment_changes = @consultation.payment_changes.order(:created_at)
      render json: payment_changes
    end

    def create
      @payment_change = @consultation.payment_changes.build(payment_change_params)

      if @payment_change.save && @consultation.update(payment: payment_change_params[:updated_payment])
        send_notification

        render json: { success: true, errors: [] }
      else
        render json: { errors: @payment_change.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def payment_change_params
      params.require(:change_payment).permit(*PaymentChange::ATTRIBUTE_WHITELIST).merge(
        user_id:        current_user.id,
        previous_payment: @consultation.payment
      )
    end

    def fetch_consultation
      @consultation = Consultation.find(params[:consultation_id])
    end

    def send_notification
      subject, message = Notifications::Messages::Builder.new(@payment_change).call
      Notifications::Sender.new(subject, message).call
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
