class WelcomeController < ApplicationController
  def index
    if @now_time > @start_time
      redirect_to root_path
    end
  end
end
