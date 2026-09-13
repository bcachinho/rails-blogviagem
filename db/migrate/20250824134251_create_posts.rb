class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.string :slug
      t.text :content
      t.text :excerpt
      t.boolean :published, default: false, null: false
      t.datetime :published_at
      t.string :featured_image

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
