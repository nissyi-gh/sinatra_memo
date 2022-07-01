ENV['APP_ENV'] = 'test'

require_relative './app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  TEST_HOST = 'http://example.org/'

  def app
    Sinatra::Application
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
    title = 'test_title'
    content = 'example_text'

    post '/memos', { title: title, content: content }
    follow_redirect!
    assert last_response.ok?
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, title
    assert_includes last_response.body, content
  end

  def test_post_valid_memo_not_include_content
    title = 'test_title'
    content = nil

    post '/memos', { title: title, content: content }
    follow_redirect!
    assert last_response.ok?
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, title
  end

  def test_post_invalid_memo_because_not_include_title
    title = ''
    content = 'example_text'

    post '/memos', { title: title, content: content }
    follow_redirect!
    assert_equal TEST_HOST, last_request.url
    assert_includes last_response.body, 'タイトルが入力されていません。'
  end
end
