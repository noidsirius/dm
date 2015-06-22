class Profile < ActiveRecord::Base
  before_validation :username_downcase
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/,
                                    message: "only allows letters and numbers" }
  after_create :set_credit

  def set_credit
    Invoice.create!(profile_id: id, amount: 1000)
  end


  mount_uploader :avatar, AvatarUploader

  acts_as_voter

  belongs_to :user

  has_and_belongs_to_many :followers, class_name: 'Profile', foreign_key: 'followee_id', join_table: 'follow_lists', association_foreign_key: 'follower_id'
  has_and_belongs_to_many :following, class_name: 'Profile', foreign_key: 'follower_id', join_table: 'follow_lists', association_foreign_key: 'followee_id'

  has_and_belongs_to_many :problems, class_name: 'Problem', foreign_key: 'problem_id', join_table: 'bought_problems', association_foreign_key: 'profile_id'
  has_and_belongs_to_many :submited_problems, class_name: 'Problem', foreign_key: 'problem_id', join_table: 'submissions', association_foreign_key: 'profile_id'
  has_many :submissions
  #has_many :alaki_prob, class_name: 'Problem', join_table


  #has_many :bought_problems
  #has_many :problems , through: :bought_problems

  has_many :comments, :dependent => :delete_all
  has_many :contests
  has_many :TeamsOwned, class_name: "Team", foreign_key: "profile_id"
  has_many :bids
  has_many :auctions, through: :bids
  has_many :invoices

  validates :first_name, presence: true, length: {minimum: 1, maximum: 32}
  validates :last_name, presence: true, length: {minimum: 1, maximum: 32}
  validates :info, length: {maximum: 80}
  validates :about, length: {maximum: 300}
  validates :username, presence: true, length: {minimum: 3, maximum: 32}
  validates_uniqueness_of :username, :case_sensetive => false
  validates_inclusion_of :is_female, :in => [true, false]

  def get_unsolved_problems
    problems - Problem.joins(:submissions).merge( Submission.where("status = 2 and profile_id = ?", id) )
  end

  def get_solved_problems
    solved = []
    #Problem.joins(:)
    #submissions.where("status = 2")
    Problem.joins(:submissions).merge( Submission.where("status = 2 and profile_id = ?", id) )
  end

  def get_pending_problems
    solved = []
    #Problem.joins(:)
    #submissions.where("status = 2")
    Problem.joins(:submissions).merge( Submission.where("status = 0 and profile_id = ?", id) )
  end


  def follow(profile)
    if profile and profile != self
      if self.following.include?(profile)
        return false
      else
        self.following << profile
        return true
      end
    end
    false
  end

  def get_credit()
    invoices.sum(:amount)
  end

  def buy(problem)
    if problem
      if self.problems.include?(problem) or problem.auction_mode?() or problem.profiles.count >= problem.buy_limit or self.problems.count >= 4
        return false
      else
        #self.credit -= problem.level.price
        if problem.auction_mode?()
          Bid.where("id = ?",problem.auction.bids.order(:created_at).last.id).update_all("status = 2")
        else
          Invoice.create!(profile_id: id, amount: -problem.level.price)
        end
        self.problems << problem
        self.save
        return true
      end
    end
    false
  end

  def won_auction(problem, bid)
    if problem
      if  self.problems.include?(problem) or !problem.auction_mode?()
        return false
      else
        Bid.where("id = ?",bid.id).update_all("status = 2")
        self.problems << problem
        self.save
        return true
      end
    end
    false
  end

  def submit(problem)
    if problem
      if self.submited_problems.include?(problem)
        return false
      else
        self.submited_problems << problem
        return true
      end
    end
    false
  end

  def unfollow(profile)
    if profile and profile != self
      if self.following.include?(profile)
        self.following.delete(profile)
        return true
      else
        return false
      end
    end
  end

  def get_age
    today = Date.today
    age = today.year - self.birth_day.year
    if today.month < self.birth_day.month or (today.month == self.birth_day.month and today.day < self.birth_day.day)
      age = age - 1
    end
    age
  end

  protected
  def username_downcase
    if self.username
      self.username = self.username.downcase
    end
  end
end
