require_relative '../lib/dom_parser'
require_relative '../lib/dom_tree'

class NodeRenderer
  def initialize(tree)
    @nodes = tree.to_a
  end

  def render(node)
    tag = @nodes.find { |n| n == node }

    return "Could not find node: #{node} in tree." if tag.nil?

    sub_nodes = nodes_in_subtree(tag, [])
    statistics = "The subtree has #{sub_nodes.size} nodes.\n"
    # statistics += report_node_types(sub_nodes)
    statistics
  end


  def nodes_in_subtree(tag, sub_nodes)
    []
  end

  private

  def report_node_types(sub_nodes)
    types = sub_nodes.each_with_object({}) do |tag, type_count|
      if type_count[tag.type]
        type_count[tag.type] += 1
      else
        type_count[tag.type] = 1
      end
    end

    types
  end
end

RSpec.describe NodeRenderer do
  describe 'TEMPORARY: #nodes_in_subtree' do
    it 'returns empty array if no sub tree' do
      tree = DomTree.new
      nr = NodeRenderer.new(tree)
      expect(nr.nodes_in_subtree(tree.root_node, [])).to eq []
    end
    it 'returns the correct nodes' do
      tree = DomTree.new
      html_tag = TagElement.new('html')
      text_tag = TextElement.new('text', 'some text', [])
      html_tag.children = [text_tag]
      tree.root_node.children << html_tag
      nr = NodeRenderer.new(tree)

      expect(nr.nodes_in_subtree(tree.root_node, []).map(&:type)).to eq %w(html text)
    end
  end
  describe '#render' do
    describe 'total nodes in node subtree' do
      let(:tree) { DomTree.new }

      context 'new dom tree with just one root node' do
        it 'returns 0' do
          renderer = NodeRenderer.new(tree)
          expect(renderer.render(tree.root_node)).to match /subtree has 0 nodes\.?/i
        end
      end

      context 'dom tree has some nested nodes' do
        it 'it returns the correct count' do
          html_tag = TagElement.new('html')
          text_tag = TextElement.new('text', 'some text', [])
          html_tag.children = [text_tag]
          tree.root_node.children << html_tag

          renderer = NodeRenderer.new(tree)
          expect(renderer.render(tree.root_node)).to match /subtree has 2 nodes\.?/i
          expect(renderer.render(html_tag)).to match /subtree has 1 nodes\.?/i
        end
      end
    end

    describe 'node type count in subtree' do
      let(:div_tag) { TagElement.new('div') }
      let(:tree) do
        tree = DomTree.new
        p_tag = TagElement.new('p')

        p_tag.children = [TextElement.new('text', 'some paragraph text', [])]
        div_tag.children = [p_tag, TextElement.new('text', 'some div text', [])]
        tree.root_node.children << div_tag
        tree
      end

      it 'provides count of subtree node types' do
        nr = NodeRenderer.new(tree)
        results = nr.render(div_tag)
        expect(results).to match /1 <p> tags/
        expect(results).to match /2 text tags/
      end
    end
  end
end