require 'sinatra'
require 'sinatra/reloader'
require_relative './memo'

get '/' do
  @memos = Memo.all
  erb :index
end

not_found do
  'ページが見つかりませんでした。'
end

post '/memos' do
  memo = Memo.create(title: params[:title], content: params[:content])

  redirect to('/')
end
