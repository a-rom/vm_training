Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/' => 'top#index'
  get '/create' => 'top#create'
  post '/create_vm' => 'top#create_vm'
  get '/pending' => 'top#pending'
  post '/pending_vm' => 'top#pending_vm'
  get '/rebooting' => 'top#rebooting'
  post '/rebooting_vm' => 'top#rebooting_vm'
  get '/resuming' => 'top#resuming'
  post '/resuming_vm' => 'top#resuming_vm'
  get '/destroy' => 'top#destroy'
  post '/destroy_vm' => 'top#destroy_vm'
  get '/starting' => 'top#starting'
  post '/starting_vm' => 'top#starting_vm'
  get '/sshkey' => 'top#sshkey'
  post '/create_sshkey' => 'top#create_sshkey'

end
