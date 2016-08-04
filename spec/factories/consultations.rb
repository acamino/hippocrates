FactoryGirl.define do
  factory :consultation do
    reason               'reason'
    ongoing_issue        'ongoing issue'
    organs_examination   'organs examination'
    temperature          'temperature'
    heart_rate           'heart rate'
    blood_pressure       'blood pressure'
    respiratory_rate     'respiratory rate'
    weight               'weight'
    height               'height'
    physical_examination 'physical examination'
    right_ear            'right ear'
    left_ear             'left ear'
    right_nostril        'right nostril'
    left_nostril         'left nostril'
    nasopharynx          'nasopharynx'
    nose_others          'nose others'
    oral_cavity          'oral cavity'
    oropharynx           'oropharynx'
    hypopharynx          'hypopharynx'
    larynx               'larynx'
    neck                 'neck'
    others               'others'
    next_appointment     '2016-01-11'

    patient
  end

  trait :with_diagnoses do
    diagnoses { [Diagnosis.create(disease_code: 'A01', description: 'disease')] }
  end
end
