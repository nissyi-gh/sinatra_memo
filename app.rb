# frozen_string_literal: true

require 'sinatra/base'
# 終了時に不具合が発生するのでコメントアウト
# require 'sinatra/reloader'
require_relative './memo'

class App < Sinatra::Application
  include ERB::Util
  error = nil
  ERROR_MESSAGE_WITHOUT_TITLE = 'タイトルが入力されていません。'

  Memo.load

  get '/' do
    @memos = Memo.all_ignore_deleted
    @error = request.url == request.referer ? error : nil
    erb :index
  end

  not_found do
    'ページが見つかりませんでした。'
  end

  post '/memos' do
    memo = Memo.create(title: html_escape(params[:title]), content: html_escape(params[:content]))
    error = memo ? nil : ERROR_MESSAGE_WITHOUT_TITLE

    redirect to('/')
  end

  get '/memos/:memo_id' do
    @memo = Memo.find(params[:memo_id])
    @error = request.url == request.referer ? error : nil
    erb :edit
  end

  delete '/memos/:memo_id' do
    Memo.delete(params[:memo_id])
    redirect to('/')
  end

  patch '/memos/:memo_id' do
    if params[:title].empty?
      error = ERROR_MESSAGE_WITHOUT_TITLE
      redirect to("/memos/#{params[:memo_id]}")
    else
      memo = Memo.find(params[:memo_id])
      memo.patch(title: html_escape(params[:title]), content: html_escape(params[:content]))
      redirect to('/')
    end
  end

  run! if app_file == $PROGRAM_NAME
end
