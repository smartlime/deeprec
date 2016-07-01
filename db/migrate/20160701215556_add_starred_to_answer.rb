class AddStarredToAnswer < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.boolean :starred, null: false, default: false
    end
  end
end
