require_relative '../lib/dom_parser'

RSpec.describe DomParser do
  let(:parser) { DomParser.new }

  it 'starts with a dom tree' do
    expect(parser.dom_tree).to be_a_kind_of DomTree
  end

  describe '#parse' do
    let(:html) do
      <<~EOS
        <!doctype html>
        <html>
          <head>
            <title>
              This is a test page
            </title>
          </head>
        </html>
      EOS
    end

    before { parser.parse(html) }

    it 'drops the doctype tag' do
      expect(parser.dom_tree.root_node.children.first.type).to eq 'html'
    end

    it 'parses the html' do
      html_tag = parser.dom_tree.root_node.children.first
      head_tag = html_tag.children.first
      title_tag = head_tag.children.first
      title_text = title_tag.children.first

      expect(head_tag.type).to eq 'head'
      expect(title_tag.type).to eq 'title'
      expect(title_text.content.strip).to eq 'This is a test page'

      expect(head_tag.children.size).to eq 1
    end

    context 'text with punctuation' do
      let(:html) do
        <<~EOS
          <div>
            I'm an inner div?!! (I might just) <em>emphasize</em> some text.
          </div>
        EOS
      end

      it 'parses html' do
        parser.parse(html)
        div_tag = parser.dom_tree.root_node.children.first
        children_types = div_tag.children.map(&:type)

        expect(div_tag.children.size).to eq 3
        expect(children_types).to eq %w(text em text)
      end
    end

    context 'tags with ids and classes' do
      let(:html) do
        <<~EOS
          <main id="main-area">
            <header class="super-header">
              <h1 id = "coolio" class="emphasized sub-header">
                Welcome to the test doc!
              </h1>
            </header>
          </main>
        EOS
      end

      it 'parses the tags including class and id info' do
        parser.parse(html)
        main_tag = parser.dom_tree.root_node.children.first
        header_tag = main_tag.children.first
        h1_tag = header_tag.children.first
        h1_text_tag = h1_tag.children.first

        expect(main_tag.id).to eq 'main-area'
        expect(header_tag.classes).to eq %w(super-header)
        expect(h1_tag.id).to eq 'coolio'
        expect(h1_tag.classes).to eq %w(emphasized sub-header)
        expect(h1_text_tag.content.strip).to eq 'Welcome to the test doc!'
      end
    end
  end

  describe 'rebuilding the DOM' do
    it 'lets the domtree do it' do
      parser = DomParser.new
      allow(parser).to receive :write_to_file

      expect_any_instance_of(DomTree).to receive :to_html
      parser.print_dom
    end
  end
end