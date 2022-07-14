# frozen_string_literal: true

require 'pg'

module MemoDb
  @@connect = PG::Connection.open(dbname: 'postgres')

  def self.create_table
    @@connect.exec("CREATE TABLE memos(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end

  def self.load
    @@connect.exec("SELECT * FROM memos ORDER BY id;")
  rescue StandardError
    create_table
  end

  def self.delete(memo_id)
    @@connect.exec("UPDATE memos SET deleted_at = now() WHERE id = #{memo_id}")
  end

  def self.find(memo_id)
    memo = @@connect.exec("SELECT * FROM memos WHERE id = #{memo_id};")

    memo.ntuples.zero? ? nil : memo
  end

  def self.create(title, content, created_at)
    @@connect.exec(
      <<~SQL
        INSERT INTO memos(title, content, created_at, deleted_at) VALUES (
        '#{title}',
        '#{content}',
        '#{created_at}',
        null);
      SQL
    )
  end

  def self.update(memo_id, title, content)
    @@connect.exec("UPDATE memos SET title = '#{title}', content = '#{content}' WHERE id = #{memo_id};")
  end
end
