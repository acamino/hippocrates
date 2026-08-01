# Cleans up zero-width and bidirectional formatting characters pasted into text
# fields before ApplicationRecord::INVISIBLE_CHARACTERS started stripping them
# on save. They are invisible in the UI but broke prescription PDF generation.
class StripInvisibleCharactersFromTextFields < ActiveRecord::Migration[8.1]
  COLUMNS = {
    anamneses: %i[
      medical_history surgical_history allergies observations habits family_history
    ],
    branch_offices: %i[name],
    consultations: %i[
      reason ongoing_issue organs_examination physical_examination right_ear left_ear
      right_nostril left_nostril nasopharynx nose_others oral_cavity oropharynx
      hypopharynx larynx neck others miscellaneous diagnostic_plan treatment_plan
      warning_signs recommendations hearing_aids
    ],
    diagnoses: %i[disease_code description],
    diseases: %i[code name],
    documents: %i[description],
    medicines: %i[name instructions],
    patients: %i[last_name first_name address profession health_insurance],
    payment_changes: %i[reason],
    prescriptions: %i[inscription subscription]
  }.freeze

  def up
    COLUMNS.each do |table, columns|
      columns.each { |column| strip_invisible_characters(table, column) }
    end
  end

  # The original values carry no information, so there is nothing to restore.
  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def strip_invisible_characters(table, column)
    stripped = "translate(#{column}, #{invisible_characters}, '')"

    execute(<<~SQL.squish)
      UPDATE #{table}
         SET #{column} = btrim(#{stripped})
       WHERE #{column} <> #{stripped}
    SQL
  end

  # Postgres regexes have no \u escapes, and translate/3 drops every character
  # of the second argument that has no counterpart in the third.
  def invisible_characters
    @invisible_characters ||= ApplicationRecord::INVISIBLE_CHARACTER_RANGES
                              .flat_map(&:to_a)
                              .map { |code| "chr(#{code})" }
                              .join(' || ')
  end
end
