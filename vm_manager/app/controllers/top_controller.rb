class TopController < ApplicationController

  def index
  @records = Vm.all
  end
  
  def create
  end

  def create_vm
#id1から順に検索して、nameがNULLのレコードが見つかり且つid1から5までのcpuカラムと新しく入力されるcpuの値を足し合わせて、物理サーバーの上限cpuを超えない場合
   Vm.create(vmname: params[:vmname],cpu: params[:cpu],ram: params[:ram],status: "running")
   %x(sudo sh app/controllers/install.sh #{params[:vmname]})
  end

  def destroy
  end

  def destroy_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
 if Vm.find_by(vmname: params[:vmname])
 vm.update(status: "terminating")
%x(sudo sh app/controllers/destroying.sh #{params[:vmname]})
  end

  def pending
  end

  def pending_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
if Vm.find_by(vmname: params[:vmname])
vm.update(status: "offline")
%x(sudo sh app/controllers/pending.sh #{params[:vmname]})
  end 

  def rebooting
  end

  def rebooting_vm
 if Vm.find_by(vmname: params[:vmname])
 vm.update(status: "running")
  p 'pwd'
  %x(sh app/controllers/rebooting.sh params[:vmname])
  end

  def resuming
  end

  def resuming_vm
 if Vm.find_by(vmname: params[:vmname])
 vm.update(status: "offline")
  p 'pwd'
  %x(sh app/controllers/resuming.sh params[:vmname])
  end

  def starting
  end

  def starting_vm
 if Vm.find_by(vmname: params[:vmname])
 vm.update(status: "running")
  p 'pwd'
  %x(sh app/controllers/starting.sh params[:vmname])
  end

  def sshkey
  end

  def create_sshkey
    key = {}
    filename = 'file' + Time.now.to_i.to_s
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
  end

end
