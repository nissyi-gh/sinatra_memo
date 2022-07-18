# frozen_string_literal: true

require 'sinatra/base'
require_relative './memo'

class App < Sinatra::Application
  include ERB::Util
  ERROR_MESSAGE_WITHOUT_TITLE = 'タイトルが入力されていません。'

  Memo.create_table

  get '/' do
    @memos = Memo.all

    erb :index
  end

  not_found do
    'ページが見つかりませんでした。'
  end

  post '/memos' do
    if params[:title].empty?
      @error = ERROR_MESSAGE_WITHOUT_TITLE
      @content = params[:content]
      @memos = Memo.all

      erb :index
    else
      Memo.create(title: params[:title], content: params[:content])

      redirect to('/')
    end
  end

  get '/memos/:memo_id' do
    @memo = Memo.find(params[:memo_id])

    if @memo
      erb :edit
    else
      not_found
    end
  end

  delete '/memos/:memo_id' do
    Memo.delete(params[:memo_id])

    redirect to('/')
  end

  patch '/memos/:memo_id' do
    if params[:title].empty?
      @error = ERROR_MESSAGE_WITHOUT_TITLE
      @memo = Memo.find(params[:memo_id])

      erb :edit
    else
      Memo.update(id: params[:memo_id], title: params[:title], content: params[:content])

      redirect to('/')
    end
  end

  run! if app_file == $PROGRAM_NAME
end
