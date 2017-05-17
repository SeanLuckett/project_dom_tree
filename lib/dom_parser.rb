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
        text_tag_rgex = /^[\w !.,')(?]*/

        tag_text = html_str.match(text_tag_rgex).to_s
        parent.children << parse_text_tag(tag_text)
        html_str.sub!(text_tag_rgex, '')
      end
    end
  end

  private

  def parse_tag(html)
    tag = TagElement.new
    tag.type = (/\w+/.match html).to_s
    tag.classes = (/((?<=class=('|"))|(?<=class\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s.split(' ')
    tag.id = (/((?<=id=('|"))|(?<=id\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s
    tag.children = []

    tag
  end

  def parse_text_tag(text)
    tag = TextElement.new
    tag.type = 'text'
    tag.content = text

    tag
  end

  def preprocess(html)
    html.gsub("\n", '').sub(/<!doctype ?\w+>/, '').squeeze(' ')
  end
end

TagElement = Struct.new(:type, :id, :classes, :children)
TextElement = Struct.new(:type, :content)