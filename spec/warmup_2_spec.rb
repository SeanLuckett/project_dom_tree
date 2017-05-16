class DomParser
  attr_reader :dom_tree

  def initialize(html)
    unless html[0] == '<'
      raise NoRootTagError
    end

    @html = html
  end

  def parse
    @dom_tree = create_dom_tree
  end

  def to_html
    html_string = ''

    add_tags_to_html(@dom_tree, html_string)
  end

  def add_tags_to_html(tag, html_string)
    if tag.type != 'text'
      html_string += "<#{tag.type}>\n"
    else
      html_string += "#{tag.content}\n"
    end

    return html_string if tag.children.nil?

    tag.children.each do |child|
      html_string = add_tags_to_html(child, html_string)
    end

    html_string += "</#{tag.type}>\n"
    html_string
  end


  # def add_children_to_stack(tag, stack)
  #   stack << tag
  #   return if tag.children.nil?
  #
  #   tag.children.each do |c|
  #     add_children_to_stack(c, stack)
  #   end
  # end

  private

  def create_dom_tree
    dom_elements = @html.split("\n")
    root_tag = parse_tag(dom_elements.shift)

    parse_dom_elements(dom_elements, root_tag)
  end

  def parse_dom_elements(dom_elements, root_tag)
    tag_stack = []
    tag_stack << root_tag

    dom_elements.each do |el|
      parent = tag_stack.last
      parent.children = [] if parent.children.nil?

      if el.match /<\w+/
        tag = parse_tag(el)
        parent.children << tag
        tag_stack << tag
      elsif el.match /<\/\w+/
        tag_stack.pop
      else
        parent.children << parse_text_tag(el)
      end
    end

    root_tag
  end

  def parse_tag(html)
    tag = Tag.new
    tag.type = (/\w+/.match html).to_s
    tag.classes = (/((?<=class=('|"))|(?<=class\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s.split(' ')
    tag.id = (/((?<=id=('|"))|(?<=id\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s
    tag.name = (/(?<=name=('|"))((\w+(-|_)?)+ ?)+/.match html).to_s
    tag.src = (/((?<=src=('|"))|(?<=src\s=\s('|")))[http:\/\/]*(w{3}\.)?\w+\.\w{2,3}/.match html).to_s
    tag.title = (/((?<=title=('|"))|(?<=title\s=\s('|")))(\w+ ?)+/.match html).to_s

    tag
  end

  def parse_text_tag(text)
    tag = Text.new
    tag.type = 'text'
    tag.content = text

    tag
  end
end

Tag = Struct.new(:type, :id, :classes, :name, :src, :title, :children)

Text = Struct.new(:type, :content, :children)

class NoRootTagError < StandardError;
end

RSpec.describe DomParser do
  context 'html has no root node' do
    it 'raises and error' do
      html = 'just some text'
      expect { DomParser.new(html) }.to raise_error NoRootTagError
    end
  end

  context 'single tag with text' do
    let(:html) do
      <<~EOS
        <div>
          div text before
        </div
      EOS
    end

    let(:parser) { DomParser.new(html) }

    before do
      parser.parse
    end

    it 'creates a root tag' do
      expect(parser.dom_tree).to be_a_kind_of Tag
      expect(parser.dom_tree.type).to eq 'div'
    end

    it 'creates a text tag as root tag child' do
      expect(parser.dom_tree.children.first).to be_a_kind_of Text
      expect(parser.dom_tree.children.first.content).to eq '  div text before'
    end
  end

  context 'root tag with text and one nested tag with text' do
    let(:html) do
      <<~EOS
        <div>
          div text before
          <p>
            p text
          </p>
        </div>
      EOS
    end

    let(:parser) { DomParser.new(html) }

    before do
      parser.parse
    end

    it 'sets nested tag and text children of root' do
      children = parser.dom_tree.children
      expect(children.first.type).to eq 'text'
      expect(children.last.type).to eq 'p'
    end

    it 'sets the nested tag text to child of nested tag' do
      p_tag = parser.dom_tree.children.last
      expect(p_tag.children.first.type).to eq 'text'
    end
  end

  context 'root tag with nested sibling tags' do
    let(:html) do
      <<~EOS
        <div>
          div text before
          <p>
            p text
          </p>
          <div>
            more div text
          </div>
          div text after
        </div>
      EOS
    end

    let(:parser) { DomParser.new(html) }

    before do
      parser.parse
    end

    it 'sets nested tag and text children of root' do
      children = parser.dom_tree.children
      expect(children.size).to eq 4
    end
  end

  describe 'outputting html' do
    let(:html) do
      <<~EOS
        <div>
          div text before
          <p>
            p text
          </p>
          <div>
            more div text
          </div>
          div text after
        </div>
      EOS
    end

    let(:expected_output) {
      "<div>\n  div text before\n<p>\n    p text\n</p>\n<div>\n    more div text\n</div>\n  div text after\n</div>\n"
    }

    let(:parser) { DomParser.new(html) }

    before do
      parser.parse
    end

    it 'reproduces the html it parsed' do
      expect(parser.to_html).to eq expected_output
    end
  end
end