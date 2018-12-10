class Zone < ApplicationRecord
  validates :title, :impressions, presence: true
  validates_uniqueness_of :title, :case_sensitive => false
  has_many :ads, dependent: :restrict_with_exception
end
