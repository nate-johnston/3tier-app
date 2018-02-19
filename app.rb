# myapp.rb

require 'json'
require 'sinatra/activerecord'
require 'sinatra'

class User < ActiveRecord::Base

end

get '/' do
   "Test page"
end

get '/users' do
  @users = User.all
  erb :index
end

get '/users/:id' do
  @user = JSON.generate(User.find(params[:id]))
end
