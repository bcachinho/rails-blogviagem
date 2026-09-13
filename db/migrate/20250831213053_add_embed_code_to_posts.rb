class AddEmbedCodeToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :embed_code, :text
  end
end
