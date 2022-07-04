# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative './app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  TEST_HOST = 'http://example.org/'

  def app
    App
  end

  def setup
    Memo.clear
    @title = 'test_title'
    @content = 'example_text'
    @edit = 'edit'
    @error_message_without_tile = 'タイトルが入力されていません。'
  end

  def test_home_response
    get '/'
    assert last_response.ok?
  end

  def test_not_found
    get '/hogehoge'
    assert_equal 'ページが見つかりませんでした。', last_response.body
  end

  def test_post_valid_memo
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert last_response.ok?
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content
  end

  def test_post_valid_memo_not_include_content
    @content = nil

    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert last_response.ok?
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, @title
  end

  def test_post_invalid_memo_because_not_include_title
    @title = ''

    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, @error_message_without_tile
  end

  def test_delete_memo
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content

    delete '/memos/1'
    follow_redirect!
    assert_not_includes last_response.body, @title
    assert_not_includes last_response.body, @content
  end

  def test_edit_memo_title_and_content
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content

    patch '/memos/1', { title: @title + @edit, content: @content + @edit }
    follow_redirect!
    assert_includes last_response.body, @title + @edit
    assert_includes last_response.body, @content + @edit
  end

  def test_edit_only_memo_title
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content

    patch '/memos/1', { title: @title + @edit, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title + @edit
    assert_includes last_response.body, @content
  end

  def test_edit_only_memo_content
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content

    patch '/memos/1', { title: @title, content: @content + @edit }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content + @edit
  end

  def test_fail_edit_because_nothing_title
    post '/memos', { title: @title, content: @content }
    follow_redirect!
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content

    get '/memos/1'
    patch '/memos/1', { title: '', content: @content }
    follow_redirect!
    assert last_response.ok?
    assert_equal "#{TEST_HOST}memos/1", last_request.url.encode('UTF-8')
    assert_includes last_response.body, @error_message_without_tile
    assert_includes last_response.body, @title
    assert_includes last_response.body, @content
  end
end
