module Admin
  class UsersController < ApplicationController
    before_action :authorize_admin
    before_action :fetch_user, only: [:edit, :update, :destroy]

    def index
      @users = User.search(query).page(page)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'Usuario creado correctamente'
      else
        render :new
      end
    end

    def edit; end

    def update
      if update_user!
        redirect_to admin_users_path, notice: 'Usuario actualizado correctamente'
      else
        render :edit
      end
    end

    private

    def authorize_admin
      return if current_user.admin_or_super_admin?

      redirect_to root_path, notice: 'Reservado para administradores'
    end

    def fetch_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(*User::ATTRIBUTE_WHITELIST)
    end

    def update_user!
      if user_params[:password].present?
        @user.update_attributes(user_params)
      else
        @user.update_without_password(user_params)
      end
    end
  end
end
