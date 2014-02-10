class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets
  has_many :followers

  def client
    env_config = YAML.load_file(APP_ROOT.join('config', 'twitter.yaml'))

    env_config.each do |key, value|
      ENV[key] = value
    end

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_SECRET']
    end
    client
  end

  def get_tweets
    client.user_timeline(username).shift(10).each do |tweet|
      tweets << Tweet.new(text: tweet.text, sent_at: tweet.created_at)
    end
  end

  def update_tweets
    tweets.destroy_all
    get_tweets
  end

  def stale_data?
    time_between_tweets = Array.new
    recent_tweets = tweets.order(sent_at: :asc)
    for x in 1...recent_tweets.length
      time_between_tweets.push(recent_tweets[x].sent_at.to_time - recent_tweets[x-1].sent_at.to_time)
    end
    avg_time_tweets = time_between_tweets.reduce(:+)/time_between_tweets.length.to_f/1.minute
    data_age = (Time.now - tweets.last.created_at)/1.minute
    data_age >= avg_time_tweets
  end

  def get_followers
    client.followers(username).each do |follower|
      followers << Follower.new(username: follower.username, tweet_count: follower.statuses_count)
    end
  end

  def update_followers
    followers.destroy_all
    get_followers
  end

  def stale_followers_data?
    data_age = (Time.now - followers.last.created_at)/1.day
    data_age >= 1.0
  end
end
