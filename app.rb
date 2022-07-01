require 'sinatra'
require 'sinatra/reloader'
require_relative './memo'

error = nil

get '/' do
  @memos = Memo.all
  @error = error
  erb :index
end

not_found do
  'ページが見つかりませんでした。'
end

post '/memos' do
  memo = Memo.create(title: params[:title], content: params[:content])
  error = memo ? nil : 'タイトルが入力されていません。'

  redirect to('/')
end
