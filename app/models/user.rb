class User < ApplicationRecord
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
    :admin
  ].freeze

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  validates_uniqueness_of :registration_acess

  def self.search(query)
    if query
      where('lower(pretty_name) LIKE ?', "%#{query.downcase}%")
        .order(:pretty_name)
    else
      all.order(:pretty_name)
    end
  end

  def next_serial!
    self.serial = serial.succ
    save!

    serial
  end

  def admin_or_super_admin?
    admin? || super_admin?
  end
end
