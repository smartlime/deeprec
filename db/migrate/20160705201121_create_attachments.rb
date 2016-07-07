class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true
      t.string :file

      t.timestamps null: false
    end

    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
