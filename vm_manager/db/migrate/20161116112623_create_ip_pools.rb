class CreateIpPools < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_pools do |t|
      t.integer :ip
      t.integer :use_vm_id
      t.timestamps
    end
  end
end
