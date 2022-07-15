# frozen_string_literal: true

require 'sinatra/base'
# 終了時に不具合が発生するのでコメントアウト
# require 'sinatra/reloader'
require_relative './memo'

class App < Sinatra::Application
  include ERB::Util
  ERROR_MESSAGE_WITHOUT_TITLE = 'タイトルが入力されていません。'

  MemoDb.create_table
  Memo.load_from_db

  get '/' do
    @memos = Memo.without_deleted
    erb :index
  end

  not_found do
    'ページが見つかりませんでした。'
  end

  post '/memos' do
    if params[:title].empty?
      @error = ERROR_MESSAGE_WITHOUT_TITLE
      @content = params[:content]
      @memos = Memo.without_deleted

      erb :index
    else
      begin
        Memo.create(title: params[:title], content: params[:content])
      rescue PG::InvalidTextRepresentation
        not_found
      else
        redirect to('/')
      end
    end
  end

  get '/memos/:memo_id' do
    @memo = Memo.find(params[:memo_id])
  rescue PG::InvalidTextRepresentation
    not_found
  else
    if @memo
      erb :edit
    else
      not_found
    end
  end

  delete '/memos/:memo_id' do
    Memo.delete(params[:memo_id])
  rescue PG::InvalidTextRepresentation
    not_found
  else
    redirect to('/')
  end

  patch '/memos/:memo_id' do
    memo = Memo.find(params[:memo_id])
  rescue PG::InvalidTextRepresentation
    not_found
  else
    if params[:title].empty?
      @error = ERROR_MESSAGE_WITHOUT_TITLE
      @memo = memo

      erb :edit
    else
      memo.patch(title: params[:title], content: params[:content])
      redirect to('/')
    end
  end

  run! if app_file == $PROGRAM_NAME
end
