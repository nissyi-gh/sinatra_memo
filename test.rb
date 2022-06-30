ENV['APP_ENV'] = 'test'

require_relative './app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

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
    assert_equal 'http://example.org/', last_request.url
    assert_includes title, last_response.body
    assert_includes content, last_response.body
  end
end
