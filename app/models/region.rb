class Region < ApplicationRecord
  has_many :cities
  has_many :news
end
