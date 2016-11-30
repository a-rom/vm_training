class RemoveSecretkeyFromSshkey < ActiveRecord::Migration[5.0]
  def change
  	remove_column :sshkeys, :secret_key
  end
end
