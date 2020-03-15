class HomeController < ApplicationController

  caches_page :public

  # Nothing -> render the view
  # get 'home/index'
  def index;
  end

end
