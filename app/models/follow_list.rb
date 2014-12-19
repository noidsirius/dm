class FollowList < ActiveRecord::Base
  belongs_to :follower,
             :class_name => 'Profile', :foreign_key => 'follower_id'
  belongs_to :followee,
             :class_name => 'Profile', :foreign_key => 'followee_id'
end
