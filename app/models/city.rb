class City < ApplicationRecord
  has_many :news
  belongs_to :region

end
