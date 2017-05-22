require_relative '../lib/tree_searcher'

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
        child_div1 = TagElement.new('div', '', %w(main-nav float-right))
        child_div2 = TagElement.new('div')

        child_div1.children << child_div2
        parent_div.children << child_div1
        tree.root_node.children << parent_div

        expect(searcher.search_ancestors(child_div2, :class, 'float-right'))
          .to eq [child_div1, parent_div]
      end
    end

    context 'when searching by id' do
      it 'returns descendents whose id matches' do
        parent_div = TagElement.new('div', 'main-nav')
        child_div1 = TagElement.new('div', 'sub-nav')
        child_div2 = TagElement.new('div')

        child_div1.children << child_div2
        parent_div.children << child_div1
        tree.root_node.children << parent_div

        expect(searcher.search_ancestors(child_div1, :id, 'nav'))
          .to eq [parent_div]
      end
    end
  end
end