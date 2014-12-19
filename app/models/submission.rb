class Submission < ActiveRecord::Base

  belongs_to :profile
  belongs_to :problem

  after_create :set_status

  def set_status
    self.status = 0
    self.save
  end
end
