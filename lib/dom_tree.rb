class DomTree
  attr_reader :root_node

  def initialize
    @root_node = TagElement.new('document')
    @root_node.children = []
  end

end
