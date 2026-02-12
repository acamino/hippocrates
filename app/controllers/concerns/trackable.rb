module Trackable
  extend ActiveSupport::Concern

  def track_activity(instance, key)
    instance.create_activity key, owner: current_user
  end
end
