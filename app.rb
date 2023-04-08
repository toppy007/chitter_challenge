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

  def invalid_request_parameters?
    return true if params[:title].nil? || params[:title].empty? ||
                    params[:content].nil? || params[:content].empty? ||
                    params[:tags].nil? || params[:tags].empty?
  
    false
  end
end