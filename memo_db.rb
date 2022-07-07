# frozen_string_literal: true

require 'pg'

module MemoDb
  MEMOS_TABLE_NAME = 'memos'
  CONNECT = PG::Connection.open(dbname: 'postgres')

  def self.create_table
    CONNECT.exec("CREATE TABLE #{MEMOS_TABLE_NAME}(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end

  def self.load
    begin
      CONNECT.exec("SELECT * FROM #{MEMOS_TABLE_NAME};")
    rescue
      create_table
    end
  end

  def self.delete(memo_id)
    CONNECT.exec("UPDATE #{MEMOS_TABLE_NAME} SET deleted_at = now() WHERE id = #{memo_id}")
  end

  def self.create(memo)
    CONNECT.exec("INSERT INTO #{MEMOS_TABLE_NAME}(title, content, created_at, deleted_at) VALUES (
      '#{memo.title}',
      '#{memo.content}',
      '#{memo.created_at}',
      null
    );")
  end
end
