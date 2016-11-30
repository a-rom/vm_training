class TopController < ApplicationController

before_filter :authenticate_user!

  def index
  @records = Vm.where(user_id:current_user.id).all
  end
  
  def create
  end

  def create_vm
#vmnameと同内容がVmテーブルのuser_idカラムに存在する場合
if !Vm.exists?(vmname: params[:vmname],user_id:current_user.id)
#物理サーバーのCPUの上限に到達している場合
  if MAX_CPU < Vm.sum(:cpu)+ params[:cpu].to_i
   flash.now[:danger] = 'CPUの空きがありません' 
   render 'create'
#物理サーバーのRAMの上限に到達している場合
 elsif MAX_RAM < Vm.sum(:ram) + params[:ram].to_i
   flash.now[:danger] = 'RAMの空きがありません' 
   render 'create'
#未使用のSSH鍵がない場合
  elsif !Sshkey.exists?(email:current_user.email,use_vm_id:0)
   flash.now[:danger] = '未使用のSsh用の鍵がありません' 
   render 'create'
#未使用のIPアドレスがない場合
  elsif !IpPool.exists?(use_vm_id:0)
   flash.now[:danger] = 'IPアドレスの空きがありません' 
   render 'create'

  else
Vm.create(vmname: params[:vmname],cpu: params[:cpu],ram: params[:ram],status: "initialize",user_id:current_user.id)
ip_record = IpPool.where(use_vm_id:0).first
newest_vm_id = Vm.order("id desc").first.id
ip_record.use_vm_id = newest_vm_id
ip_record.save
secret_key_record = Sshkey.where(email:current_user.email,use_vm_id:0).first
secret_key_record.use_vm_id = newest_vm_id
secret_key_record.save
%x(sh /root/vm_training/vm_manager/app/controllers/initializing.sh #{params[:vmname]} #{params[:cpu]} #{params[:ram]} #{ip_record.ip} "#{secret_key_record.public_key}")
  flash[:success] ='新しいVMを作る事ができました'
  redirect_to action: 'index'
  end

else
   flash.now[:danger] = 'すでに同名のVMが存在します' 
   render 'create'

end

  end

  def destroy
  end

  def destroy_vm
##vmnameと同内容がVmテーブルのuser_idカラムに存在する場合
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 destroy_vm = Vm.find_by(vmname: params[:vmname])
 destroy_vm.status ="terminating"
 destroy_vm.save
 flash[:success] = 'VMを停止しました'
 redirect_to action: 'index'
 %x(sh /root/vm_training/vm_manager/app/controllers/destroying.sh #{params[:vmname]})
 

 else
   flash.now[:danger] = 'VMを停止できませんでした'
   render 'destroy'

 end
end

  def starting
  end

  def starting_vm
##vmnameと同内容がVmテーブルのuser_idカラムに存在する場合
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 starting_vm = Vm.find_by(vmname: params[:vmname])
 starting_vm.status ="starting"
 starting_vm.save
  %x(sh /root/vm_training/vm_manager/app/controllers/starting.sh  #{params[:vmname]})
flash[:success] = 'VMを起動しました'
redirect_to action: 'index'

 else
   flash.now[:danger] = 'VMを起動できませんでした'
   render 'starting'
 end

end

  def delete
  end

  def delete_vm
##vmnameと同内容がVmテーブルのuser_idカラムに存在する場合
if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 delete_vm = Vm.find_by(vmname: params[:vmname])
 delete_vm_id = delete_vm.id
 ip_record = IpPool.find_by(use_vm_id:delete_vm_id)
 ssh_record = Sshkey.find_by(use_vm_id:delete_vm_id)
ip_record.use_vm_id = 0
ip_record.save
ssh_record.use_vm_id = 0
ssh_record.save
 delete_vm.destroy
 flash[:success] = 'VMを削除しました'
 redirect_to action: 'index'
 %x(sh /root/vm_training/vm_manager/app/controllers/deleting.sh #{params[:vmname]})


 else
   flash.now[:danger] = 'VMを削除できませんでした'
   render 'delete'
 end

end



  def sshkey
  end

  def create_sshkey
#鍵を生成する
    key = {}
    filename = 'earlycloud' + Time.now.to_i.to_s
    path = '/tmp/'
    cmd = "ssh-keygen -q -t rsa -N '' -f '#{path}#{filename}' >/dev/null && openssl rsa -in #{path}#{filename} -outform pem > #{path}#{filename}.pem "

    system(cmd)
    result = ''
    f = open("#{path}#{filename}.pub", 'r')
    f.each do |line|
      result += line
    end
    
    f.close
    key[:result] = result
    key[:name] = filename
    key

#公開鍵の中身を出力して、DBに格納する
   public_key_content = `awk '{printf "%s",$0}' #{path}#{filename}.pub`
  Sshkey.create(email: current_user.email,public_key: public_key_content)
  flash[:success] = '鍵を作成しました'
 redirect_to action: 'index'

  end
end
