class News < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :photos
  # has_many :comments
  belongs_to :site
  belongs_to :city
  belongs_to :region

  scope :last_date, -> { order('date desc').first.date rescue Date.new(2009,11,26).to_time }
end
