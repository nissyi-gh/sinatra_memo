require 'sinatra'
require 'sinatra/reloader'
require_relative './memo'

get '/' do
  erb :index
end

not_found do
  'ページが見つかりませんでした。'
end
