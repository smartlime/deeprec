class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :topic, null: false, limit: 50
      t.text :body, null: false, limit: 8192
      t.integer :rating, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
