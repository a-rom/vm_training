class TopController < ApplicationController

before_filter :authenticate_user!

  def index
  @records = Vm.where(user_id:current_user.id).all
  end
  
  def create
  end

  def create_vm
#id1から順に検索して、nameがNULLのレコードが見つかり且つid1から5までのcpuカラムと新しく入力されるcpuの値を足し合わせて、物理サーバーの上限cpuを超えない場合
Vm.create(vmname: params[:vmname],cpu: params[:cpu],ram: params[:ram],status: "initialize",user_id:current_user.id)
ip_record = IpPool.where(use_vm_id:nil).first
newest_vm_id = Vm.order("id desc").first.id
ip_record.use_vm_id = newest_vm_id
ip_record.save
secret_key_record = Sshkey.where(email:current_user.email,use_vm_id:nil).first
binding.pry
secret_key_record.use_vm_id = newest_vm_id
secret_key_record.save
%x(sh /root/vm_training/vm_manager/app/controllers/initializing.sh #{params[:vmname]} #{params[:cpu]} #{params[:ram]} #{ip_record.ip} #{secret_key_record.secret_key})
  redirect_to action: 'index'
  end

  def destroy
  end

  def destroy_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 destroy_vm = Vm.find_by(vmname: params[:vmname])
 destroy_vm.status ="terminating"
 destroy_vm.save
 redirect_to action: 'index'
 %x(sh /root/vm_training/vm_manager/app/controllers/destroying.sh #{params[:vmname]})
 end

  end

  def starting
  end

  def starting_vm
 if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 starting_vm = Vm.find_by(vmname: params[:vmname])
 starting_vm.status ="starting"
 starting_vm.save
 redirect_to action: 'index'
 %x(sh /root/vm_training/vm_manager/app/controllers/starting.sh  #{params[:vmname]})
 end
  end

  def delete
  end

  def delete_vm
if Vm.find_by(vmname: params[:vmname],user_id:current_user.id)
 starting_vm = Vm.find_by(vmname: params[:vmname])
 starting_vm.destroy
 redirect_to action: 'index'
 %x(sh /root/vm_training/vm_manager/app/controllers/deleting.sh #{params[:vmname]})
end
 end



  def sshkey
  end

  def create_sshkey
    key = {}
    filename = 'testfile' + Time.now.to_i.to_s
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

   secret_key_content = `awk '{printf "%s",$0}' #{path}#{filename}.pem`
  Sshkey.create(email:current_user.email,secret_key: secret_key_content)
  end
end
