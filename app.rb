#\ -p 80
# myapp.rb

require 'json'
require 'sinatra/activerecord'
require 'sinatra'
require "sinatra/cors"
require "sinatra/json"

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Cors
  set :allow_origin, "http://example.com http://foo.com"
  set :allow_methods, "GET,HEAD,POST"
  set :allow_headers, "content-type,if-modified-since"
  set :expose_headers, "location,link"

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
end

class User < ActiveRecord::Base
  validates_presence_of :name

  def to_json(*a)
    { :id => id, :name => name, :address => address }.to_json(*a)
  end
end
