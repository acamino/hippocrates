class Medicine < ActiveRecord::Base
  validates :name,
            :instructions, presence: true

  validates :name, uniqueness: true
end
