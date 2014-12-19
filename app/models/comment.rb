class Comment < ActiveRecord::Base
  belongs_to :profile
  belongs_to :commentable, polymorphic: true

  def days_ago
    (Time.now.in_time_zone('Tehran').to_date - self.created_at.in_time_zone('Tehran').to_date).to_i
  end
end
