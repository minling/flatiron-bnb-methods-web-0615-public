# == Schema Information
#
# Table name: listings
#
#  id              :integer          not null, primary key
#  address         :string
#  listing_type    :string
#  title           :string
#  description     :text
#  price           :decimal(8, 2)
#  neighborhood_id :integer
#  host_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User", foreign_key: "host_id"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :to_host
  before_destroy :change_host_status_to_false, if: :only_listing

  def to_host
    my_host = self.host
    my_host.host = true
    my_host.save
    #host.update(host: true) 
  end

  def change_host_status_to_false
    host.update(host: false)
  end

  def only_listing
    host.listings.count == 1
  end

  def average_review_rating
    reviews.pluck(:rating).reduce(:+)/reviews.count.to_f
  end
 
  #need to be fixed
  def not_available?(start_date, end_date)
    reservations.any? {|reservation| (reservation.checkin..reservation.checkout).overlaps?(start_date..end_date)}
  end

#listing belongs to a host. A User is considered a host, when that user's '.host' is 'true'
#When a new listing is created, that listing's user must have it's `host` attr changed to true
# we need to create a callback method, that achieves the above (changes that user's host value to true,
 # WHEN the listing is created)
#so, after you create that callback you add a macro on top: when a listing is crated, fire this new method
end
