# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'anamnesis', 'anamneses'
  inflect.irregular 'diagnosis', 'diagnoses'

  inflect.acronym 'API'
end
