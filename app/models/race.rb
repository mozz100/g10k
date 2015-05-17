class Race < ActiveRecord::Base
	has_many :runners

	def self.reset
		# Delete all races; create one and add all runners.
		Race.delete_all
		CheckPoint.delete_all
		race = Race.create
		race.runners = Runner.all
	end

    def started?
        !self.start_time.nil?
    end

    def state
        return "unstarted" if not self.started?
        return "finished"  if self.runners.select{|r| r.finished? }.length == self.runners.count
        "running"
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

    def as_json
        this = super
        this["start_time"] = this["start_time"].to_i * 1000 if this["start_time"]
        ["created_at", "updated_at"].each {|x| this.delete(x)}
        this["state"] = self.state
        this["runners"] = self.runners.as_json
        return this
    end
end
