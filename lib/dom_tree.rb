require_relative './tag_element'

class DomTree
  attr_reader :root_node

  def initialize
    @root_node = TagElement.new('document')
  end

  def to_html
    html_string = "<!doctype html>\n"
    html_string += @root_node.children.first.to_html
    html_string
  end
end
