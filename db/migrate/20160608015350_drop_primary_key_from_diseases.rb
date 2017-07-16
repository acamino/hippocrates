class DropPrimaryKeyFromDiseases < ActiveRecord::Migration[5.1]
  def up
    execute %Q{ ALTER TABLE "diseases" DROP CONSTRAINT "diseases_pkey"; }
  end

  def down
    execute %Q{ ALTER TABLE "diseases" ADD PRIMARY KEY ("code"); }
  end
end
