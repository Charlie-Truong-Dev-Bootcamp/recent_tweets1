class Follower < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :TwitterUser
end
