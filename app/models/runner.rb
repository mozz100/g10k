class Runner < ActiveRecord::Base
	belongs_to :race

    def start_time
        self.race.started? ? self.race.expected_finish_time - self.expected_duration.seconds : nil
    end

    def expected_checkpoint(percent)
        return nil if not self.race.started?
        return self.start_time + (percent/100.0) * self.expected_duration.seconds
    end
end
