# myapp.rb
#
set :port, 80

require 'json'
require 'sinatra/activerecord'
require 'sinatra'

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

class User < ActiveRecord::Base
  validates_presence_of :name
end

get '/' do
   p "Test page"
end

get '/users' do
  @users = User.all
  print @users
  erb :index
end

get '/users/:id' do
  @user = JSON.generate(User.find(params[:id]))
end
