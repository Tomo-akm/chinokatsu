class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :favorite_language, :string
    add_column :users, :research_lab, :string
    add_column :users, :internship_count, :integer
    add_column :users, :personal_message, :text
  end
end
