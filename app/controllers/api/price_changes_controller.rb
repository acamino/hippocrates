module API
  class PriceChangesController < BaseController
    before_action :fetch_consultation

    def index
      price_changes = @consultation.price_changes.order(:created_at)
      render json: price_changes
    end

    def create
      @price_change = @consultation.price_changes.build(price_change_params)

      if @price_change.save && @consultation.update(price: price_change_params[:updated_price])
        send_notification

        render json: { success: true, errors: [] }
      else
        render json: { errors: @price_change.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def price_change_params
      params.require(:change_price).permit(*PriceChange::ATTRIBUTE_WHITELIST).merge(
        user_id:        current_user.id,
        previous_price: @consultation.price
      )
    end

    def fetch_consultation
      @consultation = Consultation.find(params[:consultation_id])
    end

    def send_notification
      subject, message = Notifications::Messages::Builder.new(@price_change).call
      Notifications::Sender.new(subject, message).call
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
