require_relative './tag_element'

class DomTree
  attr_reader :root_node

  def initialize
    @root_node = TagElement.new('document')
  end

  def all_nodes
    add_tags_to_array(@root_node, [])
  end

  def to_html
    html_string = "<!doctype html>\n"
    html_string += @root_node.children.first.to_html
    html_string
  end

  private

  def add_tags_to_array(tag, collection)
    collection << tag

    return collection if tag.children.empty?

    tag.children.each do |child|
      add_tags_to_array(child, collection)
    end

    collection
  end
end
