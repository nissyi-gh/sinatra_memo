# frozen_string_literal: true

require_relative './memo_db'

class Memo
  extend MemoDb

  attr_reader :id
  attr_accessor :title, :content, :created_at, :deleted_at

  def initialize(id, title, content, created_at, deleted_at = nil)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
    @deleted_at = deleted_at
  end

  class << self
    def all
      load_from_db
    end

    def all_ignore_deleted
      load_from_db.reject(&:delete?)
    end

    def new_id
      load_from_db.size + 1
    end

    def convert_pg_result_to_memo(memo)
      memo.transform_keys!(&:to_sym)
      Memo.new(
        memo[:id].to_i,
        memo[:title],
        memo[:content],
        DateTime.parse(memo[:created_at]),
        memo[:deleted_at] ? DateTime.parse(memo[:deleted_at]) : nil
      )
    end

    def find(memo_id)
      memo = MemoDb.find(memo_id)

      convert_pg_result_to_memo(memo[0]) if memo
    end

    def create(title:, content: nil)
      return if title.empty?

      memo = Memo.new(new_id, title, content, Time.now)
      MemoDb.create(memo)
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

  def to_h
    {
      id: id,
      title: title,
      content: content,
      created_at: created_at,
      deleted_at: deleted_at
    }
  end

  def delete?
    !deleted_at.nil?
  end
end
