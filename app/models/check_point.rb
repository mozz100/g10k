class CheckPoint < ActiveRecord::Base
    belongs_to :runner
    validates :runner_id, :percent, :check_time, presence: true
end
