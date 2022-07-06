# frozen_string_literal: true

require 'pg'

module MemoDb
  MEMOS_TABLE_NAME = 'memos'
  CONNECT = PG::Connection.open(dbname: 'postgres')

  def create_table
    CONNECT.exec("CREATE TABLE #{MEMOS_TABLE_NAME}(
      id SERIAL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TIMESTAMP NOT NULL DEFAULT now(),
      deleted_at TIMESTAMP DEFAULT null);")
  end
end
