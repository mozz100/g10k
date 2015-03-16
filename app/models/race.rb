class Race < ActiveRecord::Base
	has_many :runners

	def self.reset
		# Delete all races; create one and add all runners.
		Race.delete_all
		race = Race.create
		race.runners = Runner.all
	end
end
