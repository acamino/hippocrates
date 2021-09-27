class User < ApplicationRecord
  include PgSearch::Model

  ATTRIBUTE_WHITELIST = [
    :first_name,
    :last_name,
    :pretty_name,
    :speciality,
    :phone_number,
    :email,
    :registration_acess,
    :password,
    :active,
    :admin,
    :doctor,
    :editor
  ].freeze

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validates_uniqueness_of :registration_acess

  scope :active_doctor, -> { active.physician.order(:pretty_name) }
  scope :active,        -> { where(active: true) }
  scope :physician,     -> { where(doctor: true) }

  pg_search_scope :lookup,
    against:  :pretty_name,
    using:    { tsearch: { prefix: true } },
    ignoring: :accents

  def self.search(query)
    (query.present? ? lookup(query) : all).order(
      super_admin: :desc,
      active: :desc,
      pretty_name: :asc
    )
  end

  def next_serial!
    self.serial = serial.succ
    save!

    serial
  end

  def admin_or_super_admin?
    admin? || super_admin?
  end

  def editor?
    editor || super_admin?
  end
end
