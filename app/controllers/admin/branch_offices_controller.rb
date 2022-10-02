module Admin
  class BranchOfficesController < ApplicationController
    before_action :authorize_admin
    before_action :fetch_branch_office, only: [:edit, :update, :destroy]

    def index
      @branch_offices = BranchOffice.search(query).page(page)
    end

    def new
      @branch_office = BranchOffice.new
    end

    def create
      @branch_office = BranchOffice.new(branch_office_params)
      if @branch_office.save
        redirect_to admin_branch_offices_path, notice: t('branch_offices.success.creation')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @branch_office.update(branch_office_params)
        redirect_to admin_branch_offices_path, notice: t('branch_offices.success.update')
      else
        render :edit
      end
    end

    def destroy
      @branch_office.destroy
      redirect_to admin_branch_offices_path, notice: t('branch_offices.success.destroy')
    end

    private

    def fetch_branch_office
      @branch_office = BranchOffice.find(params[:id])
    end

    def branch_office_params
      params.require(:branch_office).permit(*BranchOffice::ATTRIBUTE_WHITELIST)
    end
  end
end
