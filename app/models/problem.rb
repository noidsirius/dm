class Problem < ActiveRecord::Base
  belongs_to :level
  #has_many :bought_problems
  #has_many :profiles , through: :bought_problems

  has_and_belongs_to_many :profiles, class_name: 'Profile', foreign_key: 'profile_id', join_table: 'bought_problems', association_foreign_key: 'problem_id'
  has_and_belongs_to_many :chapters, class_name: 'Chapter', foreign_key: 'chapter_id', join_table: 'problem_chapters', association_foreign_key: 'problem_id'
  #has_and_belongs_to_many :submited_profiles, class_name: 'Profile', foreign_key: 'profile_id', join_table: 'submissions', association_foreign_key: 'problem_id'
  has_many :submissions
  #has_many :ss_profiles, :through => :submissions, :class_name => "Profile"
  
  has_one :auction
  def auction_mode?()
    return auction
  end
  def can_view(profile)
    self.profiles.include?(profile) or auction_mode?
  end
  def can_submit(profile)
    if self.profiles.include?(profile)
      return true
    end
    if auction_mode?()
      bid = auction.bids.where("status = 2").first
      if bid and bid.profile == profile
        return true
      end
    end
    return false;
    #(auction and auction.bids.where("status = 2").first.profile == profile)
  end

  def can_buy(profile)
    if self.profiles.include?(profile) or self.auction_mode?()
      return false
    end
    if profile.problems.where("level_id = 1").count > 3 + profile.problems.where("level_id = 2").count * 2 + profile.problems.where("level_id = 3").count * 3
      return false
    end
    return true
  end

end
