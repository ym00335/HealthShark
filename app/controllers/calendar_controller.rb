class CalendarController < ApplicationController
  before_action :authenticate_user!
  skip_forgery_protection

  def index
  end
end
