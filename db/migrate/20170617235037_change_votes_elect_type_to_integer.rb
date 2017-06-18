class ChangeVotesElectTypeToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :votes, :elect, 'integer USING CAST(elect AS integer)'
  end
end
