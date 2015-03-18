json.array!(@runners) do |runner|
  json.extract! runner, :id, :name, :email, :expected_duration
  json.url runner_url(runner, format: :json)
end
