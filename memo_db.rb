# frozen_string_literal: true

require 'pg'

module MemoDb
  MEMOS_TABLE_NAME = 'memos'
  connect = PG::Connection(dbname: 'postgres')

  def create_table
    connect.exec("CLEATE TABLE #{MEMOS_TABLE_NAME}(
      id INTEGER,
      title TEXT,
      content TEXT,
      created_at TIMESTAMP,
      deleted_at TIMESTAMP;)"
    )
  end
end
