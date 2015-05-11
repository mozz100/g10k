class Runner < ActiveRecord::Base
	belongs_to :race
    has_many :check_points

    validates :name, :email, :expected_duration, :race_id, presence: true

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
        self.check_points.order("percent DESC").first
    end

    def finished?
        latest_checkpoint and latest_checkpoint.percent == 100
    end

    def started?(actual_time: Time.now)
        self.start_time and self.start_time >= actual_time
    end

    def actual_finish_time
        self.latest_checkpoint.check_time if self.finished?
    end

    def status
        return "finished" if self.finished?
        return "running" if self.started?
        return "unstarted"
    end

    def as_json
        this = super(include: :check_points)
        this["expected_finish_time"] = self.expected_finish_time
        this["start_time"] = self.start_time
        this["actual_finish_time"] = self.actual_finish_time
        this["status"] = self.status
        return this
    end
end
