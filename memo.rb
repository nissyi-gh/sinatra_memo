class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at

  @@file = File.open('./memos.json', 'a')
  @@instances = []

  def initialize(id, title, content = nil, created_at)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
  end

  def self.all
    @@instances
  end

  def self.new_id
    @@instances.size + 1
  end

  def self.create(title:, content: nil)
    puts title
    if title
      memo = Memo.new(self.new_id, title, content, DateTime.now)

      @@instances << memo
    end
  end

  def save
    # ファイルへの保存処理を書く
  end
end
