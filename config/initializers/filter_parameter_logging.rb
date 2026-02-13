# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :allergies,
  :medical_history,
  :surgical_history,
  :family_history,
  :identity_card_number,
  :health_insurance
]
