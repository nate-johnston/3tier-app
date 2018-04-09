#\ -p 80
# myapp.rb

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
  #erb :index
  JSON.generate(Array.new(User.all))
end

get '/users/:id' do
  @user = JSON.generate(User.find(params[:id]))
end
