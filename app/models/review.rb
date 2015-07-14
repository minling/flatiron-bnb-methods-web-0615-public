# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  description    :text
#  rating         :integer
#  guest_id       :integer
#  reservation_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :reservation_has_been_accepted

  validate :checkout_has_happened

  def reservation_has_been_accepted
    unless reservation && reservation.status == "accepted"
      errors.add(:reservation, "Reservation must be present")
    end
  end

  def checkout_has_happened
    unless reservation && reservation.checkout < Date.today
      errors.add(:review, "Can't write a review before checkout")
    end
  end

end
