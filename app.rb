require 'sinatra'
require 'sinatra/reloader'
require_relative './memo'

get '/' do
  erb :index
end