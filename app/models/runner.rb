class Runner < ActiveRecord::Base
	belongs_to :race
    has_many :check_points

    def start_time
        self.race.started? ? self.race.expected_finish_time - self.expected_duration.seconds : nil
    end

    def expected_checkpoint(percent_wanted)
        # Estimate the time at which runner will reach percent_wanted of the race
        return nil if not self.race.started?

        if latest_checkpoint
            # Extrapolate: speed = distance/time. time = speed/dist
            speed = latest_checkpoint.percent / (latest_checkpoint.check_time - self.start_time)
            return self.start_time + percent_wanted / speed
        else
            return self.start_time + (percent_wanted/100.0) * self.expected_duration.seconds
        end
    end

    def expected_finish_time
        return expected_checkpoint(100)
    end

    def latest_checkpoint
        self.check_points.order("check_time DESC").last
    end

    def finished?
        latest_checkpoint and latest_checkpoint.percent >= 100
    end
end
