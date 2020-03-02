class HomeController < ApplicationController

  caches_page :public
  caches_action :index, expires_in: 1.minute
  # Nothing -> render the view
  # get 'home/index'
  def index;
  end

end
