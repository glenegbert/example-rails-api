class Zone < ApplicationRecord
  validates :title, :impressions, presence: true
  has_many :ads, dependent: :restrict_with_exception
end
