module Auth
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        unless user.active?
          sign_out
          redirect_to new_user_session_path, notice: 'Tu usuario está inactivo.'
          return
        end
      end
    end
  end
end
