# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  host       :boolean          default(FALSE)
#


class User < ActiveRecord::Base
  # has_many :listings, :foreign_key => 'host_id'
  # has_many :reservations, :through => :listings
  # has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  # has_many :reviews, :foreign_key => 'guest_id'
  # has_many :guests, through: :listings
  # has_many :guest_reservations, foreign_key: 'guest_id', :class_name => 'Reservation'
  # has_many :hosts, through: :reviews, :source => :guests
  #for lab review--correct answers
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations
  # delegate :host, to: :listing ---> or use host method
  has_many :guest_listings, through: :trips, source: :listing
  #want to know about the listings through the reservations 
  has_many :hosts, through: :guest_listings

  has_many :host_reviews, through: :reservations, source: :review
  #when going to reservations, it has_one review, so you go up the chain. source is top, through is middle, 
  #has_many is bottom and what you want

  #or use delegates 
  # def host
  #   listing.host
  # end

  # def hosts
  #   self.guest_reservations.map(&:listing).map(&:host)  
  # end

  # def host_reviews
  #   self.guests.collect do |guest|
  #     guest.reviews
  #   end
  # end
    
end







