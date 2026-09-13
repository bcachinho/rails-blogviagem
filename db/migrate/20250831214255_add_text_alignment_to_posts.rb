class AddTextAlignmentToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :text_alignment, :string, default: "left"
  end
end
