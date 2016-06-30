class DiseasesController < ApplicationController
  def index
    @diseases = Disease.search(query).page(page)
  end

  def new
    @disease = Disease.new
  end

  def create
    @disease = Disease.new(disease_params)
    if @disease.save
      # XXX: Pull out the messages form a locale file.
      redirect_to diseases_path, notice: 'Enfermedad creada correctamente'
    else
      render :new
    end
  end

  def edit
    @disease = Disease.find(params[:id])
  end

  def update
    @disease = Disease.find(params[:id])
    if @disease.update_attributes(disease_params)
      redirect_to diseases_path, notice: 'Enfermedad actualizada correctamente'
    else
      render :edit
    end
  end

  private

  def disease_params
    params.require(:disease).permit(:code, :name)
  end
end
