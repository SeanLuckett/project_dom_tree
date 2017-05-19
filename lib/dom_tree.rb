require_relative './tag_element'

class DomTree
  attr_reader :root_node

  def initialize
    @root_node = TagElement.new('document')
  end

  def to_html
    add_tags_to_html(@root_node, '')
  end

  private

  def add_tags_to_html(tag, html_string)
    html_string += if tag.type == 'document'
                     "<!doctype html>\n"
                   elsif tag.type != 'text'
                     build_full_tag(tag)
                   else
                     "#{tag.content}\n"
                   end

    return html_string unless tag.children?

    tag.children.each do |child|
      html_string = add_tags_to_html(child, html_string)
    end

    html_string += "</#{tag.type}>\n" unless tag.type == 'document'
    html_string
  end

  def build_full_tag(tag)
    tag_text = "<#{tag.type}"
    tag_text += " id=\"#{tag.id}\"" unless tag.id.empty?
    tag_text += " class=\"#{tag.classes.join(' ')}\"" unless tag.classes.empty?
    tag_text += ">\n"
    tag_text
  end
end
