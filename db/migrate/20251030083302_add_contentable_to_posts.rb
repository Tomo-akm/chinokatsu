class AddContentableToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :contentable, polymorphic: true, null: true
    # データ移行後に null: false にする
  end
end
