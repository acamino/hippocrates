class AddSearchVectorToPatients < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      CREATE OR REPLACE FUNCTION immutable_unaccent(text)
      RETURNS text AS $$
        SELECT public.unaccent('public.unaccent', $1);
      $$ LANGUAGE sql IMMUTABLE PARALLEL SAFE;
    SQL

    execute <<~SQL
      ALTER TABLE patients ADD COLUMN search_vector tsvector
        GENERATED ALWAYS AS (
          to_tsvector('simple', immutable_unaccent(
            coalesce(first_name, '') || ' ' ||
            coalesce(last_name, '') || ' ' ||
            coalesce(identity_card_number, '')
          ))
        ) STORED;
    SQL

    add_index :patients, :search_vector, using: :gin, name: 'idx_patients_search'
  end

  def down
    remove_index :patients, name: 'idx_patients_search'
    remove_column :patients, :search_vector
    execute "DROP FUNCTION IF EXISTS immutable_unaccent(text);"
  end
end
