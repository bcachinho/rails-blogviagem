class CreateEmbeds < ActiveRecord::Migration[7.2]
  def change
    create_table :embeds do |t|
      t.references :post, null: false, foreign_key: true
      t.string :title
      t.text :code

      t.timestamps
    end
  end
end
