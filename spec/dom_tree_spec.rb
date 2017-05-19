require_relative '../lib/dom_tree'
require_relative '../lib/dom_parser'

RSpec.describe DomTree do
  let(:tree) { DomTree.new }

  it 'has a root node' do
    expect(tree.root_node).to be_kind_of TagElement
    expect(tree.root_node.type).to eq 'document'
  end

  it 'sets root_node children to empty' do
    expect(tree.root_node.children.empty?).to be_truthy
  end

  describe 'rebuilding the dom' do
    let(:html) do
      <<~EOS
        <!doctype html>
        <html>
          <head>
            <title>
              This is a test page
            </title>
          </head>
          <body>
            <div class="top-div">
              I'm an outer div!!!
              <div id="inner-div">
                I'm an inner div!!! I might just <em>emphasize</em> some text.
              </div>
              I am EVEN MORE TEXT for the SAME div!!!
            </div>
          </body>
        </html>
      EOS
    end

    let(:expected_output) {
      "<!doctype html>\n<html>\n<head>\n<title>\nThis is a test page\n</title>\n</head>\n<body>\n<div class=\"top-div\">\nI'm an outer div!!!\n<div id=\"inner-div\">\nI'm an inner div!!! I might just\n<em>\nemphasize\n</em>\nsome text.\n</div>\nI am EVEN MORE TEXT for the SAME div!!!\n</div>\n</body>\n</html>\n"
    }

    let(:parser) { DomParser.new }

    before do
      parser.parse(html)
    end

    it 'reproduces the html it parsed' do
      dom_tree = parser.dom_tree
      expect(dom_tree.to_html).to eq expected_output
    end
  end
end
