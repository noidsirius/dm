class Bid < ActiveRecord::Base
  validate :check_previous_price
  validate :check_time_limits
  validate :price , presence: true
  belongs_to :profile
  belongs_to :auction

  after_create :take_and_give_credit

  def take_and_give_credit
    Bid.where("auction_id = ?", auction_id).where("status = ?", 0).where("id != ?", id).each do |bid|
      #bid.status = 1
      #bid.save
      Invoice.create!(profile_id: bid.profile_id, amount: bid.price)
    end
    Bid.where("auction_id = ?", auction_id).where("status = ?", 0).where("id != ?", id).update_all("status = 1")
    Invoice.create!(profile_id: profile_id, amount: -price)
  end

  def check_previous_price
    if price > Profile.find(profile_id).get_credit()
      errors.add(:price, "can't be more than your credit")
    else
      last_bid = Bid.where("auction_id = ?", auction_id).last
      if last_bid
        if last_bid.price >= price
          errors.add(:price, "can't be less than last bid, you must bid more than " + last_bid.price.to_s())
        end
      else
        auction = Auction.find(auction_id)
        if auction.base_price > price
          errors.add(:price, "can't be less than base price, you must bid more than " + auction.base_price.to_s())
        end
      end

    end
  end

  def check_time_limits
    auction = Auction.find(auction_id)
    if auction.start_time.localtime() >= Time.now
      errors.add(:auction, "has not been started yet!")
    elsif auction.end_time.localtime() < Time.now
      errors.add(:auction, "is finished!")
    end
  end
end
