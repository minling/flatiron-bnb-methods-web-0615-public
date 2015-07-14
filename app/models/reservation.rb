# == Schema Information
#
# Table name: reservations
#
#  id         :integer          not null, primary key
#  checkin    :date
#  checkout   :date
#  listing_id :integer
#  guest_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :string           default("pending")
#

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User", foreign_key: "guest_id"
  has_one :review

  # delegate :host, to: :listing
  # validates :checkin, :checkout, presence: true
  validates :checkin_checkout, confirmation: true
  validates :check_listing, confirmation: true
  # validates :listing_available, confirmation: true

  before_save :check_listing

  validate :listing_is_available


  def checkin_checkout
    errors.add(:checkout, "can't be the same as checkin") if checkin == checkout
    errors.add(:checkout, "can't checkout before checkin") if (checkin.nil? || checkout.nil? || checkout < checkin)
  end

  def check_listing
    errors.add(:guest, "can't make reservation on your own listing") if (self.listing.nil?) || self.guest_id == self.listing.host_id
    # if guest == host 
    #   errors.add(:reservation, "You cannot reserve your own listing")
    # end
  end

#need to fix -- also in listing.rb
  def listing_is_available
    if (checkin && checkout) && self.listing.not_available?(checkin, checkout)
      errors.add(:reservation, "listing is not available during those dates")
    end
  end

  def checkin_before_checkout
    if (checkin && checkout) && checkin >= checkout 
      errors.add(:reservation, "checkin date needs to be before checkout")
    end
  end

  def duration
    checkout = self.checkout.to_s.split(/-/).last.to_i 
    checkin = self.checkin.to_s.split(/-/).last.to_i
    checkout - checkin
  end

  def total_price
    self.listing.price.to_i * duration
  end

end
