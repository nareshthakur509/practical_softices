class User < ApplicationRecord
    has_many :work_logs, dependent: :destroy
    validates :name, presence: true

    validates :preferred_working_hour_per_day, numericality: { greather_than_or_equal_to: 0, less_than_or_equal_to: 16 }

end
