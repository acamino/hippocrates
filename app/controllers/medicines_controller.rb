class MedicinesController < ApplicationController
  def index
    @medicines = Medicine.all
  end

  def new
    @medicine = Medicine.new
  end

  def create
    @medicine = Medicine.new(medicine_params)
    if @medicine.save
      # XXX: Pull out the messages form a locale file.
      redirect_to medicines_path, notice: 'Medicina creada correctamente'
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
      redirect_to medicines_path, notice: 'Medicina actualizada correctamente'
    else
      render :edit
    end
  end

  private

  def medicine_params
    params.require(:medicine).permit(:name, :instructions)
  end
end
