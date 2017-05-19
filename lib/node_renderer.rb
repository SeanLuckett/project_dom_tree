require_relative '../lib/dom_tree'

class NodeRenderer
  def initialize(tree)
    @tree = tree
  end

  def render(node)
    node = @tree.root_node if node.nil?
    node_count = count_nodes_in_subtree(node, 0)
    statistics = "The subtree has #{node_count} nodes.\n\n"

    statistics += "Subtree node type counts:\n"
    node_types = node_type_count(node, {})
    statistics += "#{type_count_report(node_types)}\n"

    statistics += attributes_report(node)
    statistics
  end

  private

  def attributes_report(node)
    attributes = 'id: '
    attributes += node.id.empty? ? "none\n" : "#{node.id}\n"

    attributes += 'classes: '
    attributes += node.classes.any? ? "#{node.classes.join(', ')}\n" : "no classes\n"
    attributes
  end

  def count_nodes_in_subtree(node, node_count = 0)
    if node.children?
      node_count += node.children.size

      node.children.each do |child|
        node_count = count_nodes_in_subtree(child, node_count)
      end
    end

    node_count
  end

  def node_type_count(node, type_obj = {})
    if node.children?
      node.children.each do |child|
        if type_obj.has_key? child.type
          type_obj[child.type] += 1
        else
          type_obj[child.type] = 1
        end

        type_obj = node_type_count(child, type_obj)
      end
    end
    type_obj
  end

  def type_count_report(node_types)
    return "N/A\n" if node_types.keys.count.zero?

    types = ''
    node_types.each_pair do |type, count|
      types += "<#{type}>: #{count} nodes\n"
    end

    types
  end
end