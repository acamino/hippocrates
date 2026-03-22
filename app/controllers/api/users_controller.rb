module API
  class UsersController < ApplicationController
    def index
      users = User.search(params[:query]).limit(40)
      render json: { suggestions: users.map { |u| UserResource.new(u).to_h } }
    end
  end
end
