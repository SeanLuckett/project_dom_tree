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
end
