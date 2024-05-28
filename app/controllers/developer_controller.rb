class DeveloperController < ApplicationController
  before_action :authenticate_user!, :only_dev!

  def index
    
  end
end
