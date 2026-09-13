class RemovePasswordDigestFromUsers < ActiveRecord::Migration[7.0]
  def up
    # remove apenas se a coluna existir (evita erro em ambientes diferentes)
    remove_column :users, :password_digest if column_exists?(:users, :password_digest)
  end

  def down
    # recria a coluna como string caso seja necessário reverter
    add_column :users, :password_digest, :string unless column_exists?(:users, :password_digest)
  end
end
