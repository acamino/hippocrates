module API
  class PaymentChangesController < BaseController
    before_action :fetch_consultation

    def index
      render json: payment_changes.order(created_at: :desc)
    end

    def create
      @payment_change = @consultation.payment_changes.build(payment_change_params)

      if @payment_change.save
        send_notification if paid?

        render json: { success: true, errors: [] }
      else
        render json: { errors: @payment_change.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def payment_change_params
      params.require(:change_payment).permit(*PaymentChange::ATTRIBUTE_WHITELIST).merge(
        user_id: current_user.id
      )
    end

    def fetch_consultation
      @consultation = Consultation.find(params[:consultation_id])
      @consultation.current_user = current_user
    end

    def send_notification
      subject, message = Notifications::Messages::Builder.new(@payment_change).call
      Notifications::Sender.new(subject, message).call
    rescue StandardError => e
      Rails.logger.error(e.message)
    end

    def payment_changes
      if paid?
        @consultation.payment_changes.paid
      else
        @consultation.payment_changes.pending
      end
    end

    def paid?
      params[:type] == 'paid'
    end
  end
end
