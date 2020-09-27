class DiseasesController < ApplicationController
  before_action :fetch_disease, only: [:edit, :update, :destroy]

  def index
    @diseases = Disease.search(query).page(page)
  end

  def new
    @disease = Disease.new
  end

  def create
    @disease = Disease.new(disease_params)
    if @disease.save
      redirect_to diseases_path, notice: t('diseases.success.creation')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @disease.update_attributes(disease_params)
      redirect_to diseases_path, notice: t('diseases.success.update')
    else
      render :edit
    end
  end

  def destroy
    @disease.destroy
    redirect_to diseases_path, notice: t('diseases.success.destroy')
  end

  private

  def fetch_disease
    @disease = Disease.find(params[:id])
  end

  def disease_params
    params.require(:disease).permit(:code, :name)
  end
end
