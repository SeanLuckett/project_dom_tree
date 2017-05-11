Tag = Struct.new(:type, :id, :classes, :name, :src, :title)

def parse_tag(html)
  tag = Tag.new
  tag.type = (/\w+/.match html).to_s
  tag.classes = (/((?<=class=('|"))|(?<=class\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s.split(' ')
  tag.id = (/((?<=id=('|"))|(?<=id\s=\s('|")))((\w+(-|_)?)+ ?)+/.match html).to_s
  tag.name = (/(?<=name=('|"))((\w+(-|_)?)+ ?)+/.match html).to_s
  tag.src = (/((?<=src=('|"))|(?<=src\s=\s('|")))[http:\/\/]*(w{3}\.)?\w+\.\w{2,3}/.match html).to_s
  tag.title = (/((?<=title=('|"))|(?<=title\s=\s('|")))(\w+ ?)+/.match html).to_s

  tag
end

RSpec.describe 'parsing a single HTML tag' do
  let(:paragraph) { "<p class='foo bar' id='baz' name='fozzie'>" }
  let(:div)       { "<div id = 'bim'>" }

  describe '#parse_tag' do
    context 'tags with classes, id, or a name' do
      it 'assigns a type' do
        expect(parse_tag(paragraph).type).to eq 'p'
        expect(parse_tag(div).type).to eq 'div'
      end

      it 'assigns classes' do
        expect(parse_tag(paragraph).classes).to eq %w(foo bar)
        expect(parse_tag(div).classes).to eq []
      end

      it 'assigns id' do
        expect(parse_tag(paragraph).id).to eq 'baz'
        expect(parse_tag(div).id).to eq 'bim'
      end

      it 'assigns name' do
        expect(parse_tag(paragraph).name).to eq 'fozzie'
        expect(parse_tag(div).name).to eq ''
      end
    end

    context 'tag with src and title' do
      let(:image) { "<img src='http://www.example.com' title='funny things'>" }

      it 'assigns a source' do
        expect(parse_tag(image).src).to eq 'http://www.example.com'
      end

      it 'assigns a title' do
        expect(parse_tag(image).title).to eq 'funny things'
      end
    end
  end
end