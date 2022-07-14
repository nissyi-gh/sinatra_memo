# frozen_string_literal: true

require 'pg'

module MemoDb
  CONNECT = PG::Connection.open(dbname: 'postgres')

  def self.create_table
    CONNECT.exec("CREATE TABLE memos(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end

  def self.load
    CONNECT.exec("SELECT * FROM memos;")
  rescue StandardError
    create_table
  end

  def self.delete(memo_id)
    CONNECT.exec("UPDATE memos SET deleted_at = now() WHERE id = #{memo_id}")
  end

  def self.create(memo)
    CONNECT.exec("INSERT INTO memos(title, content, created_at, deleted_at) VALUES (
      '#{memo.title}',
      '#{memo.content}',
      '#{memo.created_at}',
      null
    );")
  end

  def self.update(memo_id, title, content)
    CONNECT.exec("UPDATE memos SET title = '#{title}', content = '#{content}' WHERE id = #{memo_id};")
  end

  def self.delete_test_case
    CONNECT.exec("DELETE FROM memos WHERE title = 'test_title';")
  end
end
