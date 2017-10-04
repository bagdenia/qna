class CreateAtms < ActiveRecord::Migration[5.1]
  def change
    create_table :atms do |t|
      t.string :address
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end
end
