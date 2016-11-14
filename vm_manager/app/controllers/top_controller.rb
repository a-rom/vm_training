class TopController < ApplicationController

  def index
  @records = Vm.all
  end
  
  def create
  end

  def create_vm
#id1から順に検索して、nameがNULLのレコードが見つかり且つid1から5までのcpuカラムと新しく入力されるcpuの値を足し合わせて、物理サーバーの上限cpuを超えない場合
   Vm.create(vmname: params[:vmname],status: "running")

   %x(sudo sh app/controllers/install.sh #{params[:vmname]})
  end

  def destroy
  end

  def destroy_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
%x(sudo sh app/controllers/destroying.sh #{params[:vmname]})
  end

  def pending
  end

  def pending_vm
#vmnameとparams[:vmname]}が同じ値だった場合に実行
%x(sudo sh app/controllers/pending.sh #{params[:vmname]})
  end 


  def rebooting
  end

  def rebooting_vm
  p 'pwd'
  %x(sh app/controllers/rebooting.sh params[:vmname])
  end

  def resuming
  end

  def resuming_vm
  p 'pwd'
  %x(sh app/controllers/resuming.sh params[:vmname])
  end
  def starting
  end

  def starting_vm
  p 'pwd'
  %x(sh app/controllers/starting.sh params[:vmname])
  end

end
