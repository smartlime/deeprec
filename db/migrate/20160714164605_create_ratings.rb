class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, foreign_key: true
      t.references :rateable, polymorphic: true
      t.integer :rate, null: false

      t.timestamps null: false
    end

    add_index :ratings, [:rateable_id, :rateable_type]
    add_index :ratings, [:user_id, :rateable_id, :rateable_type], unique: true
  end
end
