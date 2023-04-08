# file: app.rb

require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/message_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
    also_reload 'lib/message_repository'
  end

  get '/' do
    repo = MessageRepository.new
    @messages = repo.all 
    return erb(:index)
  end

  post '/' do
    if invalid_request_parameters?
      status 400
      return ''
    end

    title = params[:title]
    content = params[:content]
    date = params[:date]
    tags = params[:tags]
    user_id = params[:user_id]

    repo = MessageRepository.new
    new_message = Message.new

    new_message.title = params[:title]
    new_message.content = params[:content]
    new_message.date = params[:date]
    new_message.tags = params[:tags]
    new_message.user_id = params[:user_id].to_i
  
    repo.create(new_message)

    redirect "/"
  end

  def invalid_request_parameters?
    # Are the params nil?
    return true if  title = params[:title] == nil ||
                    content = params[:content] == nil ||
                    date = params[:date] == nil ||
                    tags = params[:tags] == nil ||
                    user_id = params[:user_id] == nil
  
    # Are they empty strings?
    return true if  title = params[:title] == '' ||
                    content = params[:content] == '' ||
                    date = params[:date] == '' ||
                    tags = params[:tags] == '' ||
                    user_id = params[:user_id] == ''
    return false
  end
end