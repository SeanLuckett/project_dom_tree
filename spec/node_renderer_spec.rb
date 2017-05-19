require_relative '../lib/text_element'
require_relative '../lib/node_renderer'

RSpec.describe NodeRenderer do
  let(:tree) { DomTree.new }
  let(:nr) { NodeRenderer.new(tree) }

  describe '#render' do
    describe 'node attributes' do
      let(:div_tag) do
        TagElement.new('div', 'top-div', %w(text-center float-right))
      end

      specify { expect(nr.render(div_tag)).to match /id: top-div/ }

      specify do
        expect(nr.render(div_tag)).to match /classes: text-center, float-right/
      end
    end

    describe 'total nodes in node subtree' do
      context 'new dom tree with just one root node' do
        it 'returns 0' do
          expect(nr.render(tree.root_node)).to match /subtree has 0 nodes\.?/i
        end
      end

      context 'dom tree has some nested nodes' do
        it 'it returns the correct count' do
          html_tag = TagElement.new('html')
          text_tag = TextElement.new('some text')
          html_tag.children << text_tag
          tree.root_node.children << html_tag

          expect(nr.render(tree.root_node)).to match /subtree has 2 nodes\.?/i
          expect(nr.render(html_tag)).to match /subtree has 1 nodes\.?/i
        end
      end
    end

    describe 'node type count in subtree' do
      let(:div_tag) { TagElement.new('div') }
      before do
        p_tag = TagElement.new('p')
        p_tag.children << TextElement.new('some paragraph text')

        div_tag.children << p_tag << TextElement.new('some div text')
        tree.root_node.children << div_tag
      end

      it 'provides count of subtree node types' do
        results = nr.render(div_tag)
        expect(results).to match /<text>: 2 nodes/
        expect(results).to match /<p>: 1 nodes/
      end
    end
  end
end