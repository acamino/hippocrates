class Activity < PublicActivity::Activity
  scope :by_date,       ->(date) { where(created_at: date) if date.present? }
  scope :by_owner,      ->(owner_id) { where(owner_id: owner_id) if owner_id.present? }
  scope :ordey_by_date, -> { order(created_at: :desc) }
end
