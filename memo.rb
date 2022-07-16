# frozen_string_literal: true

require_relative './memo_db'

class Memo
  extend MemoDb

  attr_reader :id
  attr_accessor :title, :content, :created_at

  def initialize(id, title, content, created_at)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
  end

  class << self
    def all
      load_from_db
    end

    def convert_pg_result_to_memo(pg_result)
      Memo.new(
        pg_result['id'].to_i,
        pg_result['title'],
        pg_result['content'],
        Time.parse(pg_result['created_at'])
      )
    end

    def find(memo_id)
      pg_result = MemoDb.find(memo_id)

      convert_pg_result_to_memo(pg_result[0]) if pg_result
    end

    def create(title:, content: nil)
      return if title.empty?

      MemoDb.create(title, content)
    end

    def delete(memo_id)
      MemoDb.delete(memo_id)
    end

    def load_from_db
      memos = MemoDb.load

      memos.map do |memo|
        convert_pg_result_to_memo(memo)
      end
    end
  end

  def patch(title:, content:)
    return if title.empty?

    self.title = title
    self.content = content
    MemoDb.update(id, title, content)
  end
end
