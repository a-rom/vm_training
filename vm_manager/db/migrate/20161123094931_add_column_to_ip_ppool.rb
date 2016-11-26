class AddColumnToIpPpool < ActiveRecord::Migration[5.0]
  def change
    remove_column :ip_pools, :ip, :integer
    add_column :ip_pools, :ip, :unsigned_bigint
    add_column :sshkeys, :use_vm_id, :integer
  end
end
