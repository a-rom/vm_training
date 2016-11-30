class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  MAX_CPU = 4
  MAX_RAM = 1000000
end
