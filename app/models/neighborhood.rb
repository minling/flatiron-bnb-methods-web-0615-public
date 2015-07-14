# == Schema Information
#
# Table name: neighborhoods
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(start_date, end_date)
    listings.joins(:reservations).where('(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? AND ?)', start_date, end_date, start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    all.max_by {|neighborhood| neighborhood.ratio}
  end

  def ratio
    if listings.count != 0 
    reservations.count/listings.count
    else
      0
    end
  end

  def self.most_res
    all.max_by {|neighborhood| neighborhood.reservations.count}
  end
end
