class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :topic, null: false, limit: 200
      t.text :body, null: false, limit: 50000
      t.integer :rating, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
