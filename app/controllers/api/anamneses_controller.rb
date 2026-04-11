module API
  class AnamnesesController < BaseController
    EDITABLE_FIELDS = %w[
      medical_history surgical_history allergies
      observations habits family_history hearing_aids
    ].freeze

    def update
      anamnesis = Anamnesis.find(params[:id])

      unless EDITABLE_FIELDS.include?(params[:name])
        return render json: { error: 'Field not editable' }, status: :unprocessable_entity
      end

      anamnesis.update!(params[:name] => params[:value])
      render json: { value: params[:value] }, status: :ok
    end
  end
end
