class Zone < ApplicationRecord
  validates :title, :impressions, presence: true
  validates_uniqueness_of :title
  has_many :ads, dependent: :restrict_with_exception

end
