require 'json'

class WelcomeController < ApplicationController
  def index
  end

  def race
  	@race = Race.first
  	render text: JSON.pretty_generate(@race.as_json), content_type: "text/json"
  end
end
