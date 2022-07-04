# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative './memo'

class App < Sinatra::Application
  include ERB::Util
  error = nil
  Memo.load

  get '/' do
    @memos = Memo.all_ignore_deleted
    @error = error
    erb :index
  end

  not_found do
    'ページが見つかりませんでした。'
  end

  post '/memos' do
    memo = Memo.create(title: html_escape(params[:title]), content: html_escape(params[:content]))
    error = memo ? nil : 'タイトルが入力されていません。'

    redirect to('/')
  end

  get '/memos/:memo_id' do
    @memo = Memo.find(params[:memo_id])
    erb :edit
  end

  delete '/memos/:memo_id' do
    Memo.delete(params[:memo_id])
    redirect to('/')
  end

  patch '/memos/:memo_id' do
    if params[:title].empty?
      redirect to("/memos/#{params[:memo_id]}")
    else
      memo = Memo.find(params[:memo_id])
      memo.patch(title: html_escape(params[:title]), content: html_escape(params[:content]))
      redirect to('.')
    end
  end

  run! if app_file == $PROGRAM_NAME
end
