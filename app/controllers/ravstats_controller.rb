class RavstatsController < ApplicationController

  def index
    @logged_in = logged_in?
  end
end
