class Ad < ApplicationRecord
  validates :creative, :priority, :start_date, :end_date, :goal, presence: true

  belongs_to :zone
end
