class Race < ActiveRecord::Base
	has_many :runners

	def self.reset
		# Delete all races; create one and add all runners.
		Race.delete_all
		race = Race.create
		race.runners = Runner.all
	end

    def started?
        !self.start_time.nil?
    end

    def slowest_runner
        self.runners.order("expected_duration DESC, id ASC").first
    end

    def expected_finish_time
        self.started? ? self.start_time + self.slowest_runner.expected_duration.seconds : nil
    end

    def start!(actual_time: Time.now)
        self.start_time = actual_time
        self.save
    end
end
