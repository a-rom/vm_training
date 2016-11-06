class CreateVms < ActiveRecord::Migration[5.0]
  def change
    create_table :vms do |t|
      t.string :vmname
      t.integer :cpu
      t.string :image
      t.string :status
      t.timestamps
    end
  end
end
