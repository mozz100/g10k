require 'json'

class WelcomeController < ApplicationController
  def index
  end

  def results
  end

  def route
  end

  def about
  end

  def admin
    @runners = Runner.all.order(:id)
  end

  def race
    output_race_data
  end
end
