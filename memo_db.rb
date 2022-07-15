# frozen_string_literal: true

require 'pg'

module MemoDb
  @@connect = if ENV['APP_ENV'] == 'test'
                PG::Connection.open(dbname: 'fjord_memo_test')
              else
                PG::Connection.open(dbname: 'fjord_memo_app')
              end

  def self.create_table
    @@connect.exec("CREATE TABLE IF NOT EXISTS memos(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end

  def self.load
    @@connect.exec_params("SELECT * FROM memos ORDER BY id;")
  end

  def self.delete(memo_id)
    @@connect.exec_params('UPDATE memos SET deleted_at = now() WHERE id = $1', [memo_id])
  end

  def self.find(memo_id)
    memo = @@connect.exec_params('SELECT * FROM memos WHERE id = $1', [memo_id])

    memo.ntuples.zero? ? nil : memo
  end

  def self.create(title, content)
    @@connect.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2)', [title, content]
    )
  end

  def self.update(memo_id, title, content)
    @@connect.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, memo_id])
  end
end
