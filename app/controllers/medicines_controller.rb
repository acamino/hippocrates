class MedicinesController < ApplicationController
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

  def edit
    @medicine = Medicine.find(params[:id])
  end

  def update
    @medicine = Medicine.find(params[:id])
    if @medicine.update_attributes(medicine_params)
      redirect_to medicines_path, notice: t('medicines.success.update')
    else
      render :edit
    end
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :instructions)
  end
end
