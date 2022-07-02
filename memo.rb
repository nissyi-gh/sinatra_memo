class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at, :deleted_at

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
    self.save
  end

  def self.delete(memo_id)
    @@instances.each do |memo|
      memo.deleted_at = DateTime.now if memo.id == memo_id.to_i
    end
    self.save
  end

  def self.find(memo_id)
    @@instances.find { |memo| memo.id == memo_id.to_i }
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

  def self.save
    memos_hash = {}
    @@instances.each { |memo| memos_hash["memo_#{memo.id}".to_sym] = memo.to_h }
    File.open('./memos.json', 'w') { |file| file.write(memos_hash.to_json) }
  end
end
