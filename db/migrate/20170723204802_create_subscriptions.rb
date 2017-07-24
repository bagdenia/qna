class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.references :question, index: true
      t.timestamps
    end
    add_foreign_key :subscriptions, :users
    add_foreign_key :subscriptions, :questions
    add_index :subscriptions, [:user_id, :question_id]
  end
end
