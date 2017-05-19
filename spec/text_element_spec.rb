require_relative '../lib/text_element'

RSpec.describe TextElement do
  let(:sample_text) { 'this is some text ' }
  let(:el) { TextElement.new(sample_text) }

  describe 'attributes' do
    specify { expect(el).to have_attributes type: 'text' }
    specify { expect(el).to have_attributes content: sample_text.strip }
  end

  describe '#children?' do
    it 'never has children' do
      expect(el.children?).to eq false
    end
  end

  describe 'to_html' do
    it 'returns its content with a newline' do
      expect(el.to_html).to eq "#{sample_text.strip}\n"
    end
  end
end