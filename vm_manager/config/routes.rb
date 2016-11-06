Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #管理しているVMの一覧表示
  get '/' => 'top#index'  
end
