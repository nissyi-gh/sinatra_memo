# frozen_string_literal: true

class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at, :deleted_at

  @instances = []
  JSON_FILE = './.memos.json'

  def initialize(id, title, content, created_at, deleted_at = nil)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
    @deleted_at = deleted_at
  end

  class << self
    def all
      load
      @instances
    end

    def all_ignore_deleted
      load
      @instances.reject(&:delete?)
    end

    def new_id
      load
      @instances.size + 1
    end

    def clear
      @instances.clear
    end

    def create(title:, content: nil)
      return if title.empty?

      memo = Memo.new(new_id, title, content, DateTime.now)
      load
      @instances << memo
      save
    end

    def delete(memo_id)
      @instances.each { |memo| memo.deleted_at = DateTime.now if memo.id == memo_id.to_i }
      save
    end

    def find(memo_id)
      @instances.find { |memo| memo.id == memo_id.to_i }
    end

    def save
      return if ENV['APP_ENV'] == 'test'

      memos_hash = {}
      @instances.each { |memo| memos_hash["memo_#{memo.id}".to_sym] = memo.to_h }
      File.open(JSON_FILE, 'w') { |file| file.write(memos_hash.to_json) }
    end

    def load
      return if File.empty?(JSON_FILE) || !File.exist?(JSON_FILE)

      memos_json = {}
      File.open(JSON_FILE, 'r') { |file| memos_json = JSON.parse(file.readline, symbolize_names: true) }

      clear
      memos_json.each_value do |memo|
        @instances << Memo.new(
          memo[:id],
          memo[:title],
          memo[:content],
          DateTime.parse(memo[:created_at]),
          memo[:daleted_at] ? DateTime.parse(memo[:deleted_at]) : nil
        )
      end
    end
  end

  def patch(title:, content:)
    return if title.empty?

    self.title = title
    self.content = content
    Memo.save
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
