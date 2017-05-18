require_relative './dom_tree'

class DomParser
  attr_reader :dom_tree

  def initialize
    @dom_tree = DomTree.new
  end

  def parse(html)
    tag_stack = []
    tag_stack << @dom_tree.root_node

    html_str = preprocess(html)

    until html_str.empty?
      parent = tag_stack.last

      if html_str =~ /^<\w+/
        tag_text = html_str.match(/^<\w+.*?>/).to_s
        tag = parse_tag(tag_text)
        parent.children << tag
        tag_stack << tag
        html_str.sub!(/^ *#{tag_text} */, '')
      elsif html_str.=~ /^<\/\w+/
        html_str.sub!(/^ *<\/\w+> */, '')
        tag_stack.pop
      else
        text_tag_rgex = /^[\w !.,')(?:]*/

        tag_text = html_str.match(text_tag_rgex).to_s
        parent.children << parse_text_tag(tag_text)
        html_str.sub!(text_tag_rgex, '')
      end
    end
  end

  def print_dom
    write_to_file @dom_tree.to_html
  end

  private

  def write_to_file(html, file_name = 'rebuilt_dom.html')
    File.open(file_name, 'w') do |f|
      f.write html
    end
  end

  def parse_tag(html)
    type = (/\w+/.match html).to_s
    classes = (/((?<=class=('|"))|(?<=class\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s.split(' ')
    id = (/((?<=id=('|"))|(?<=id\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s

    TagElement.new(type, id, classes)
  end

  def parse_text_tag(text)
    tag = TextElement.new
    tag.type = 'text'
    tag.content = text
    tag.children = []

    tag
  end

  def preprocess(html)
    html.gsub("\n", '').sub(/<!doctype ?\w+>/, '').squeeze(' ')
  end
end

TextElement = Struct.new(:type, :content, :children)