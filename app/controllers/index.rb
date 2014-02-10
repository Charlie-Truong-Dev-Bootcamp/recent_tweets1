
get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/get_tweets' do
  redirect ("/#{params[:username]}")
end

get '/:username' do
  @user = TwitterUser.find_or_create_by(username: params[:username])
  if @user.tweets.empty?
    @user.get_tweets
  elsif @user.stale_data?
    @user.update_tweets
  end
  erb :tweets
end
