class MedicinesController < ApplicationController
  before_action :fetch_medicine, only: [:edit, :update, :destroy]

  def index
    @medicines = Medicine.search(query).page(page)
  end

  def new
    @medicine = Medicine.new
  end

  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.save
      redirect_to medicines_path, notice: t('medicines.success.creation')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @medicine.update(medicine_params)
      redirect_to medicines_path, notice: t('medicines.success.update')
    else
      render :edit
    end
  end

  def destroy
    @medicine.destroy
    redirect_to medicines_path, notice: t('medicines.success.destroy')
  end

  private

  def fetch_medicine
    @medicine = Medicine.find(params[:id])
  end

  def medicine_params
    params.require(:medicine).permit(*Medicine::ATTRIBUTE_WHITELIST)
  end
end
