class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  MAX_CPU = 20
  MAX_RAM = 3
end
