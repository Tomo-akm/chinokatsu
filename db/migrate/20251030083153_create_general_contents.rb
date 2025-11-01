class CreateGeneralContents < ActiveRecord::Migration[8.1]
  def change
    create_table :general_contents do |t|
      t.timestamps
      t.text :content, null: false
    end
  end
end
