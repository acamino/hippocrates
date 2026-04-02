# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :allergies,
  :medical_history,
  :surgical_history,
  :family_history,
  :identity_card_number,
  :health_insurance,
  :email,
  :phone_number,
  :address,
  :registration_acess,
  :reset_password_token,
  :unlock_token,
  :current_sign_in_ip,
  :last_sign_in_ip
]
