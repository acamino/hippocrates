module Trackable
  extend ActiveSupport::Concern

  def track_activity(instance, key)
    instance.create_activity key, owner: current_user unless Rails.env.test?
  end
end
