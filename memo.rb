# frozen_string_literal: true

require_relative './memo_db'

class Memo
  extend MemoDb

  attr_reader :id
  attr_accessor :title, :content, :created_at, :deleted_at

  @instances = []

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
      @instances
    end

    def all_ignore_deleted
      load_from_db
      @instances.reject(&:delete?)
    end

    def new_id
      load_from_db
      @instances.size + 1
    end

    def clear
      @instances.clear
    end

    def create(title:, content: nil)
      return if title.empty?

      memo = Memo.new(new_id, title, content, Time.now)
      @instances << memo
      MemoDb.create(memo)
    end

    def delete(memo_id)
      @instances.each { |memo| memo.deleted_at = DateTime.now if memo.id == memo_id.to_i }
      MemoDb.delete(memo_id)
    end

    def find(memo_id)
      @instances.find { |memo| memo.id == memo_id.to_i }
    end

    def load_from_db
      memos = MemoDb.load

      memos.each do |memo|
        memo.transform_keys!(&:to_sym)
        @instances << Memo.new(
          memo[:id].to_i,
          memo[:title],
          memo[:content],
          DateTime.parse(memo[:created_at]),
          memo[:deleted_at] ? DateTime.parse(memo[:deleted_at]) : nil
        )
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
