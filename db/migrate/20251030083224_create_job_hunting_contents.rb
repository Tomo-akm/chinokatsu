class CreateJobHuntingContents < ActiveRecord::Migration[8.1]
  def change
    create_table :job_hunting_contents do |t|
      t.timestamps
      t.string :company_name, null: false
      t.integer :selection_stage, null: false, default: 0
      t.integer :result, null: false, default: 0
      t.text :content, null: false
    end

    add_index :job_hunting_contents, :company_name
    add_index :job_hunting_contents, :selection_stage
    add_index :job_hunting_contents, :result
  end
end
