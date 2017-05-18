require_relative '../lib/base_tag'

RSpec.describe BaseTag do
  let(:base_tag) { BaseTag.new('div') }

  it 'has a type' do
    expect(base_tag.type).to eq 'div'
  end

  describe 'methods to overwrite on inheritance' do
    describe '#to_html' do
      it 'raises and error' do
        expect {
          base_tag.to_html
        }.to raise_error(BaseMethodNotImplementedError)
               .with_message 'You must implement this method in your class.'
      end
    end

    describe '#children?' do
      it 'raises and error' do
        expect {
          base_tag.children?
        }.to raise_error(BaseMethodNotImplementedError)
               .with_message 'You must implement this method in your class.'
      end
    end
  end
end