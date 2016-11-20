class CreateSshkeys < ActiveRecord::Migration[5.0]
  def change
    create_table :sshkeys do |t|
      t.string :email
      t.string :secret_key
      t.string :public_key
      t.timestamps
    end
  end
end
