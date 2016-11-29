class ChangeDatatypeTitleOfVms < ActiveRecord::Migration[5.0]
  def change
  	change_column :vms, :ram, null: false
  	change_column :vms, :cpu, null: false
  	change_column :vms, :user_id, null: false
  	change_column :ip_pools, :use_vm_id, null: false, default: 0
   	change_column :sshkeys, :public_key, :text
  	change_column :sshkeys, :use_vm_id, null: false, default: 0
  end
end
