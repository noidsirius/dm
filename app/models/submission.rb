class Submission < ActiveRecord::Base

  mount_uploader :attachment, AttachmentUploader

  belongs_to :profile
  belongs_to :problem

  after_create :set_status

  def set_status
    self.status = 0
    self.save
  end
end
