# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    # reservations = listings.all.collect {|listing| listing.reservations.all}
    # listing_available = reservations[0].select{ |res| res.checkout < Date.parse(arrive) || res.checkin < Date.parse(leave)}.collect{ |res| res.listing_id}
    # listings.where(id: listing_available)
    listings.joins(:reservations).where('(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? AND ?)', start_date, end_date, start_date, end_date)

  end

 # 'knows the city with the highest ratio of reservations to listings'
  def self.highest_ratio_res_to_listings
  #   cities = self.all
  #   listings_count = cities.collect {|city| city.listings.count}
  #   reservations_count = cities.collect {|city| city.listings.collect {|listing| listing.reservations.count}}.map {|array| array.reduce(:+)}
  #   binding.pry
  #   ratios = reservations_count / listings_count
  #   # listings.all.collect {|listing| listing.reservations.all}
    all.max_by {|city| city.ratio}
  end

  def ratio
    reservations.count/listings.count
  end

  def self.most_res
    all.max_by {|city| city.reservations.count}
  end



end

