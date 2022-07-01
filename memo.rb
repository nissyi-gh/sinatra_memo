class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at, :deleted_at

  @@file = File.open('./memos.json', 'a')
  @@instances = []

  def initialize(id, title, content, created_at, deleted_at = nil)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
    @deleted_at = deleted_at
  end

  def self.all
    @@instances
  end

  def self.all_ignore_deleted
    @@instances.keep_if { |memo| memo.deleted_at.nil? }
  end

  def self.new_id
    @@instances.size + 1
  end

  def self.create(title:, content: nil)
    return if title.empty?

    memo = Memo.new(self.new_id, title, content, DateTime.now)
    @@instances << memo
  end

  def self.delete(memo_id)
    @@instances.each do |memo|
      memo.deleted_at = DateTime.now if memo.id == memo_id.to_i
    end
  end

  def self.find(memo_id)
    @@instances.find { |memo| memo.id == memo_id.to_i }
  end

  def patch(title:, content:)
    return if title.empty?

    self.title = title
    self.content = content
  end

  def save
    # ファイルへの保存処理を書く
  end
end
