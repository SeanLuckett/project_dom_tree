require_relative '../lib/tag_element'

RSpec.describe TagElement do
  let(:tag) { TagElement.new('div') }

  describe 'attributes' do
    specify { expect(tag).to have_attributes type: 'div' }
    specify { expect(tag).to have_attributes id: '' }
    specify { expect(tag).to have_attributes classes: [] }
    specify { expect(tag).to have_attributes children: [] }
  end

  describe '#children?' do
    it 'returns false when no children' do
      expect(tag.children?).to eq false
    end

    it 'returns true with at least one child' do
      child_tag = TagElement.new('p')
      tag.children << child_tag
      expect(tag.children?).to be true
    end
  end

  describe '#to_html' do
    context 'no children' do
      it 'returns a string with opening/closing tags' do
        expect(tag.to_html).to eq "<div>\n</div>\n"
      end

      it 'adds in id and classes if it has any' do
        type = 'div'
        id = 'top-div'
        classes = %w(center-text float-right)
        tag = TagElement.new(type, id, classes)

        expect(tag.to_html)
          .to eq "<#{type} id=\"#{id}\" class=\"#{classes.join(' ')}\">\n</#{type}>\n"
      end
    end

    context 'with children' do
      let(:expected_html) do
        <<~EOHTML
          <div id="top-div" class="center-text float-right">
          <div id="inner-div">
          </div>
          <p>
          </p>
          </div>
        EOHTML
      end

      it 'returns the string with all its child html' do
        outer_div = TagElement.new('div', 'top-div', %w(center-text float-right))
        inner_div = TagElement.new('div', 'inner-div')
        p = TagElement.new('p')

        outer_div.children << inner_div << p
        expect(outer_div.to_html).to eq expected_html
      end
    end
  end
end