class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, polymorphic: true, index: true
      t.text :body
      t.timestamps
    end
    add_foreign_key :comments, :users
    add_index :comments, [:user_id, :commentable_type, :commentable_id], name: 'index_comments_on_user_and_commentable'
  end
end
