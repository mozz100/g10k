class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def output_race_data
  	@race = Race.first
  	response.headers["Access-Control-Allow-Origin"] = "*"
  	render text: JSON.pretty_generate(@race.as_json),
  		content_type: "text/json"
  end
end
