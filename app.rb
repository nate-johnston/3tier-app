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

  def to_json(*a)
    { :id => @id, :name => @name }.to_json(*a)
  end
end

get '/' do
   p "Test page"
end

get '/users' do
  body = ""
  User.all.each do |thisuser|
    body << thisuser.to_json.to_s
    body << ','
  end
  p "[#{body.chop}]"
end

get '/users/:id' do
  @user = JSON.generate(User.find(params[:id]))
end
