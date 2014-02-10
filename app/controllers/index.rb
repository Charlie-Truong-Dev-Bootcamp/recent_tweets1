
get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/get_tweets' do
  redirect ("/#{params[:username]}")
end

get '/:username' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  @updating = false
  if @user.tweets.empty? || @user.stale_data?
    @updating = true
  end
  erb :tweets
end

post '/pull_new_tweets' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  if @user.tweets.empty?
    @user.get_tweets
  else
    @user.update_tweets
  end
  erb :_tweets_list, :layout => false
end

get '/:username/followers' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  @updating = false
  if @user.followers.empty? || @user.stale_followers_data?
    @updating = true
  end
  erb :followers
end

post '/get_followers' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  if @user.followers.empty?
    @user.get_followers
  else
    @user.update_followers
  end
  erb :_followers_list, :layout => false
end
