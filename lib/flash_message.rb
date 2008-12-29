class FlashMessage
  
  attr_reader :content, :type
  
  def initialize(content, type)
    @content = content
    @type = type
  end
  
  private
  
  def content=(content)
    @content = content
  end
  
  def type=(type)
    @type = type
  end
  
end