class Auction < ActiveRecord::Base
  belongs_to :problem
  has_many :bids
  has_many :profiles, through: :bids


  def is_started?()
    start_time.localtime() < Time.now
  end

  def is_finished?()
    end_time.localtime() < Time.now
  end
end
