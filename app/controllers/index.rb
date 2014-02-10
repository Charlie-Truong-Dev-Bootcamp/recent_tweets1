
get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/get_tweets' do
  redirect ("/#{params[:username]}")
end

get '/:username' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  if @user.tweets.empty? || @user.stale_data?
    erb :load_tweets
  else
    erb :tweets
  end
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
