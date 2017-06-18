class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.boolean :elect, null: false
      t.references :user, index: true
      t.references :votable, polymorphic: true, index: true
      t.timestamps
    end
    add_foreign_key :votes, :users
    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end
