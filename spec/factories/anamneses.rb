FactoryGirl.define do
  factory :anamnesis do
    personal_history 'personal history'
    surgical_history 'surgical history'
    allergies        'allergies'
    observations     'observations'
    habits           'habits'
    family_history   'family history'
    patient
  end
end
