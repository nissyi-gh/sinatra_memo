# frozen_string_literal: true

require 'pg'

class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at

  def initialize(id, title, content, created_at)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
  end

  class << self
    def connection
      @connection ||=
        if ENV['APP_ENV'] == 'test'
          PG::Connection.open(dbname: 'fjord_memo_test')
        else
          PG::Connection.open(dbname: 'fjord_memo_app')
        end
    end

    def all
      connection.exec_params('SELECT * FROM memos ORDER BY id;').map { |pg_result| convert_pg_result_to_memo(pg_result) }
    end

    def convert_pg_result_to_memo(pg_result)
      Memo.new(
        pg_result['id'].to_i,
        pg_result['title'],
        pg_result['content'],
        Time.parse(pg_result['created_at'])
      )
    end

    def find(memo_id)
      pg_result = connection.exec_params('SELECT * FROM memos WHERE id = $1', [memo_id])

      # クエリの結果が0件でもpg_resultインスタンスを返すが、その場合にpg_result[0]を指定するとIndexErrorになるためany?でチェック
      convert_pg_result_to_memo(pg_result[0]) if pg_result.any?
    end

    def create(title:, content: nil)
      connection.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2)', [title, content])
    end

    def create_table
      connection.exec(
        <<-SQL
          CREATE TABLE IF NOT EXISTS
            memos(
              id SERIAL,
              title TEXT NOT NULL,
              content TEXT,
              created_at TIMESTAMP NOT NULL DEFAULT now()
            );
        SQL
      )
    end

    def delete(memo_id)
      connection.exec_params('DELETE FROM memos WHERE id = $1', [memo_id])
    end
  end

  def patch(title:, content:)
    Memo.connection.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end
end
