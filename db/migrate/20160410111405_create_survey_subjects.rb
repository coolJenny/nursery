class CreateSurveySubjects < ActiveRecord::Migration
  def change
    create_table :survey_subjects do |t|
      t.string :name
      t.integer :daycare_id

      t.timestamps null: false
    end
  end
end
