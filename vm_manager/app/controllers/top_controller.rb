class TopController < ApplicationController

  def index
  @records = Vm.all
  
  end
end
