class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :color, default: '#6366f1'

      t.timestamps
    end
    add_index :categories, :slug, unique: true
  end
end
