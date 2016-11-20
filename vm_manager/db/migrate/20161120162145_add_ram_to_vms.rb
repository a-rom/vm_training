class AddRamToVms < ActiveRecord::Migration[5.0]
  def change
    add_column :vms, :ram, :integer
  end
end
