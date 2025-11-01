class MigrateExistingPostsToGeneralContents < ActiveRecord::Migration[8.1]
  def up
    # 既存の Post データを GeneralContent に移行
    execute <<-SQL
      INSERT INTO general_contents (content, created_at, updated_at)
      SELECT content, created_at, updated_at
      FROM posts
      WHERE content IS NOT NULL;
    SQL

    # posts テーブルの contentable 参照を更新
    execute <<-SQL
      UPDATE posts
      SET contentable_type = 'GeneralContent',
          contentable_id = general_contents.id
      FROM general_contents
      WHERE posts.content = general_contents.content
        AND posts.created_at = general_contents.created_at;
    SQL

    # content カラムを削除
    remove_column :posts, :content

    # contentable を必須にする
    change_column_null :posts, :contentable_type, false
    change_column_null :posts, :contentable_id, false
  end

  def down
    # ロールバック用
    add_column :posts, :content, :text

    # general_contents から content を復元
    execute <<-SQL
      UPDATE posts
      SET content = general_contents.content
      FROM general_contents
      WHERE posts.contentable_type = 'GeneralContent'
        AND posts.contentable_id = general_contents.id;
    SQL

    # contentable 参照を nullable に戻す
    change_column_null :posts, :contentable_type, true
    change_column_null :posts, :contentable_id, true
  end
end
