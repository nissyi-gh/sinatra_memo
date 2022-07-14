# frozen_string_literal: true

require 'pg'

module MemoDb
  @@connect = PG::Connection.open(dbname: 'postgres')
  @@table_name = ENV['APP_ENV'] == 'test' ? 'memos_test' : 'memos'

  def self.create_table
    @@connect.exec("CREATE TABLE #{@@table_name}(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end

  def self.load
    @@connect.exec("SELECT * FROM #{@@table_name} ORDER BY id;")
  rescue StandardError
    create_table
  end

  def self.delete(memo_id)
    @@connect.exec("UPDATE #{@@table_name} SET deleted_at = now() WHERE id = #{memo_id}")
  end

  def self.find(memo_id)
    memo = @@connect.exec("SELECT * FROM #{@@table_name} WHERE id = #{memo_id};")

    memo.ntuples.zero? ? nil : memo
  end

  def self.create(title, content, created_at)
    @@connect.exec(
      <<~SQL
        INSERT INTO #{@@table_name}(title, content, created_at, deleted_at) VALUES (
        '#{title}',
        '#{content}',
        '#{created_at}',
        null);
      SQL
    )
  end

  def self.update(memo_id, title, content)
    @@connect.exec("UPDATE #{@@table_name} SET title = '#{title}', content = '#{content}' WHERE id = #{memo_id};")
  end
end
