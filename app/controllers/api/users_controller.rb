module API
  class UsersController < ApplicationController
    def index
      users = User.search(params[:query]).limit(40)
      render json: { suggestions: users.map(&serialize) }
    end

    private

    def serialize
      ->(user) { UserSerializer.new(user) }
    end
  end
end
