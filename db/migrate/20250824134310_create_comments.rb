class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.text :content
      t.boolean :approved, default: false
      t.string :guest_name
      t.string :guest_email

      t.timestamps
    end
    add_index :comments, [:post_id, :created_at]
  end
end
