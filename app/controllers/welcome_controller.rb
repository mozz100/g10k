require 'json'

class WelcomeController < ApplicationController
  def index
  end

  def race
  	@race = Race.first
  	response.headers["Access-Control-Allow-Origin"] = "*"
  	render text: JSON.pretty_generate(@race.as_json),
  		content_type: "text/json"
  end
end
