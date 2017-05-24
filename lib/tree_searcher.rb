require_relative './tag_element'
require_relative './text_element'
require_relative './dom_tree'

class TreeSearcher
  def initialize(tree)
    @tree = tree
  end

  def search_ancestors(child_node, type, term)
    searchable_parents = find_parents(@tree.root_node, child_node, [])

    case type
      when :class
        searchable_parents.select do |parent|
          parent if parent.classes.find { |c| c.match /#{term}/ }
        end
      when :id
        searchable_parents.select do |parent|
          parent if parent.id =~ /#{term}/
        end
    end
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

  def find_parents(parent_node, sought_node, parents)
    return parents unless parent_node.children?

    if parent_node.children.include?(sought_node)
      parents << parent_node
      parents = find_parents(@tree.root_node, parent_node, parents)
    else
      parent_node.children.each do |child|
        find_parents(child, sought_node, parents)
      end
    end

    parents
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
