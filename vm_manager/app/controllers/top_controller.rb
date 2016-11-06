class TopController < ApplicationController

  def index
  @records = Vm.all  
  end
  
  def create
  end

  def create_vm
   %x(sudo sh app/controllers/install.sh #{params[:vmname]})
   Vm.create(vmname: params[:vmname],status: "running")
  end
end
