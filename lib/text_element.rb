require_relative '../lib/base_tag'

class TextElement < BaseTag
  attr_reader :content

  def initialize(content)
    @type = super('text')
    @content = content.strip
  end

  def children?
    false
  end

  def to_html
    "#{content.strip}\n"
  end
end
