class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :commentable, polymorphic: true
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
