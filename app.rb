# file: app.rb

require 'sinatra'
require "sinatra/reloader"
require 'bcrypt'
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/message_repository'


DatabaseConnection.connect

class Application < Sinatra::Base

  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
    also_reload 'lib/message_repository'
  end

  get '/' do
    repo = MessageRepository.new
    @messages = repo.all.sort_by(&:created_at).reverse
    return erb(:index)
  end

  post '/' do
    if invalid_request_parameters?
      status 400
      return ''
    end

    title = params[:title]
    content = params[:content]
    tags = params[:tags]

    repo = MessageRepository.new
    new_message = Message.new

    new_message.title = params[:title]
    new_message.content = params[:content]
    new_message.tags = params[:tags]
  
    repo.create(new_message)

    redirect '/'
  end

  get '/sign_up' do
    return erb(:sign_up)
  end

  post '/sign_up' do
    email = params[:email]
    password = params[:password]
    username = params[:username]

    repo = UserRepository.new
    new_user = User.new
    new_user.email = params[:email]
    new_user.password = params[:password]
    new_user.username = params[:username]   
    
    repo.create(new_user)

    return erb(:login)
  end

  get '/login' do
    return erb(:login)
  end

  post '/login' do
    email = params[:email]
    password = params[:password]

    repo = UserRepository.new
    user = repo.find(email)

    stored_password = BCrypt::Password.new(user.password)

    if stored_password == password
      # Set the user ID in session
      session[:user_id] = user.id

      return erb(:logged_in)
    else
      return erb(:login_error)
    end
  end

  def invalid_request_parameters?
    return true if params[:title].nil? || params[:title].empty? ||
                    params[:content].nil? || params[:content].empty? ||
                    params[:tags].nil? || params[:tags].empty?
  
    false
  end
end