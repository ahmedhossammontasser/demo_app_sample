class ApplicationController < ActionController::Base
  layout "add"
  protect_from_forgery
  include SessionsHelper
end
