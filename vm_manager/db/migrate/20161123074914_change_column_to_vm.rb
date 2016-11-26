class ChangeColumnToVm < ActiveRecord::Migration[5.0]
  def change
add_column :vms, :user_id, :integer

remove_column :vms, :image, :string
  end
end
