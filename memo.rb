class Memo
  attr_reader :id
  attr_accessor :title, :content, :created_at

  def initialize(id, title, content = nil, created_at)
    @id = id
    @title = title
    @content = content
    @created_at = created_at
  end
end
