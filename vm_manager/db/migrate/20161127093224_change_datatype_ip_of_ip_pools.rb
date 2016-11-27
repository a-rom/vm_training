class ChangeDatatypeIpOfIpPools < ActiveRecord::Migration[5.0]
  def change
  change_column :ip_pools, :ip, :string
  end
end
