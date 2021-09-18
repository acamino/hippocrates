FactoryBot.define do
  factory :anamnesis do
    medical_history  { 'medical history' }
    surgical_history { 'surgical history' }
    allergies        { 'allergies' }
    observations     { 'observations' }
    habits           { 'habits' }
    family_history   { 'family history' }
    patient
  end
end
