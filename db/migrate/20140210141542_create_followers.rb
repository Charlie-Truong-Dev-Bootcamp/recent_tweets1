class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :username
      t.integer :tweet_count
      t.belongs_to :twitter_user
      t.timestamps
    end
  end
end
