class ChangeDatatypeSecretkeyOfSshkeys < ActiveRecord::Migration[5.0]
  def change
  change_column :sshkeys, :secret_key, :text
  end
end
