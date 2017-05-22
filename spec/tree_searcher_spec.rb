require_relative '../lib/tag_element'
require_relative '../lib/text_element'
require_relative '../lib/dom_tree'

class TreeSearcher
  def initialize(tree)
    @tree = tree
  end

  def search_ancestors(node, type, term)
  end

  def search_by(type, term)
    case type
      when :class
        class_search(@tree.root_node, term, [])
      when :id
        id_search(@tree.root_node, term, [])
    end
  end

  def search_children(parent_node, type, term)
    parent_node.children.each do |child|
      case type
        when :class
          class_search(child, term, [])
        when :id
          id_search(child, term, [])
      end
    end
  end

  private

  def class_search(node, search_term, results)
    if node.children?
      node.children.each do |child|
        results = class_search(child, search_term, results)
      end
    end

    if node.classes.find { |c| c.match /#{search_term}/ }
      results << node
    end

    results
  end

  def id_search(node, search_term, results)
    if node.children?
      node.children.each do |child|
        results = id_search(child, search_term, results)
      end
    end

    results << node if node.id =~ /#{search_term}/
    results
  end
end

RSpec.describe TreeSearcher do
  let(:tree) { DomTree.new }
  let(:searcher) { TreeSearcher.new(tree) }

  describe 'searching whole tree' do
    context 'when searching by class' do
      it 'returns nodes whose class matches' do
        div_with_classes = TagElement.new('div', '', %w(text-center float-right))
        p_with_classes = TagElement.new('p', '', %w(nav float-right))
        tree.root_node.children << div_with_classes << p_with_classes

        expect(searcher.search_by(:class, 'float-right'))
          .to eq [div_with_classes, p_with_classes]
      end
    end

    context 'when searching by id' do
      it 'returns nodes whose id matches' do
        div_tag1 = TagElement.new('div', 'main-nav')
        div_tag2 = TagElement.new('div', 'sub-nav')
        tree.root_node.children << div_tag1 << div_tag2

        expect(searcher.search_by(:id, 'nav'))
          .to eq [div_tag1, div_tag2]
      end
    end

  end
  describe '#search_descendents' do
    context 'when searching by class' do
      it 'returns descendents whose class matches' do
        parent_div = TagElement.new('div')
        child_div1 = TagElement.new('div', '', %w(text-center float-right))
        child_div2 = TagElement.new('div', '', %w(text-center float-right))
        parent_div.children << child_div1 << child_div2
        tree.root_node.children << parent_div

        expect(searcher.search_children(parent_div, :class, 'float-right'))
          .to eq [child_div1, child_div2]
      end
    end

    context 'when searching by id' do
      it 'returns descendents whose id matches' do
        parent_div = TagElement.new('div', 'main-nav')
        child_div = TagElement.new('div', 'sub-nav')
        parent_div.children << child_div
        tree.root_node.children << parent_div

        expect(searcher.search_children(parent_div, :id, 'nav'))
          .to eq [child_div]
      end
    end
  end

  describe '#search_ancestors' do
    context 'when searching by class' do
      it 'returns descendents whose class matches' do
        parent_div = TagElement.new('div', '', %w(text-center float-right))
        child_div1 = TagElement.new('div', '', %w(text-center float-right))
        child_div2 = TagElement.new('div')

        child_div1.children << child_div2
        parent_div.children << child_div1
        tree.root_node.children << parent_div

        expect(searcher.search_ancestors(child_div2, :class, 'float-right'))
          .to eq [child_div1, parent_div]
      end
    end

    context 'when searching by id' do
      xit 'returns descendents whose id matches' do
        parent_div = TagElement.new('div', 'main-nav')
        child_div = TagElement.new('div', 'sub-nav')
        parent_div.children << child_div
        tree.root_node.children << parent_div

        expect(searcher.search_children(parent_div, :id, 'nav'))
          .to eq [child_div]
      end
    end
  end
end