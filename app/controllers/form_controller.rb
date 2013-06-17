class FormController < ApplicationController
  def index
    @film = Film.new
  end
end