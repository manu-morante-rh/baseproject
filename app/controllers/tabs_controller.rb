class TabsController < ApplicationController
  def index
    @film = Film.new
  end
end
