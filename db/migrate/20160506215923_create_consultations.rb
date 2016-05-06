class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.references :patient, foreign_key: true
      t.string  :reason,               default: ''
      t.string  :ongoing_issue,        default: ''
      t.string  :organs_examination,   default: ''
      t.decimal :temperature,          default: 0.0
      t.integer :heart_rate,           default: 0
      t.decimal :blood_pressure,       default: 0.0
      t.integer :respiratory_rate,     default: 0
      t.decimal :weight,               default: 0.0
      t.decimal :height,               default: 0.0
      t.string  :physical_examination, default: ''
      t.string  :right_ear,            default: ''
      t.string  :left_ear,             default: ''
      t.string  :right_nostril,        default: ''
      t.string  :left_nostril,         default: ''
      t.string  :nasopharynx,          default: ''
      t.string  :nose_others,          default: ''
      t.string  :oral_cavity,          default: ''
      t.string  :oropharynx,           default: ''
      t.string  :hypopharynx,          default: ''
      t.string  :larynx,               default: ''
      t.string  :neck,                 default: ''
      t.string  :others,               default: ''
      t.timestamps                                  null: false
    end
  end
end
