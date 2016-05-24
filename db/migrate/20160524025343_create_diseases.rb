class CreateDiseases < ActiveRecord::Migration
  def change
    create_table :diseases, id: false do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps           null: false
    end

    execute %Q{ ALTER TABLE "diseases" ADD PRIMARY KEY ("code"); }
  end
end
