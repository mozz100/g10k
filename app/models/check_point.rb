class CheckPoint < ActiveRecord::Base
    belongs_to :runner
    validates :runner_id, :percent, :check_time, presence: true

    def as_json
        this = super
        ["created_at", "updated_at", "runner_id", "id"].each {|x| this.delete(x)}
        this["percent"] = self.percent.to_i
        this["check_time"] = self.check_time.to_i * 1000
        return this
    end
end
