class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, index: true, foreign_key: true
      t.text :body, null: false, limit: 8192
      t.integer :rating, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
