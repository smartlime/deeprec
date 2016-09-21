class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, unll: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
