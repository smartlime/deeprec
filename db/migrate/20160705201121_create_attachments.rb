class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :question, index: true
      t.string :file

      t.timestamps null: false
    end

    # add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
