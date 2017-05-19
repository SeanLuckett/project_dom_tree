require_relative './base_tag'

class TagElement < BaseTag
  attr_reader :id, :classes, :children

  def initialize(type, id = '', classes = [])
    @type = super(type)
    @id = id
    @classes = classes
    @children = []
  end

  def children?
    children.any?
  end

  def to_html
    open_tag = build_open_tag
    close_tag = "</#{type}>\n"
    child_html = build_child_html

    open_tag + child_html + close_tag
  end

  private

  def build_child_html
    html = ''
    children.each { |c| html += c.to_html } if children?
    html
  end

  def build_open_tag
    open_tag = "<#{type}"
    open_tag += " id=\"#{id}\"" unless id.empty?
    open_tag += " class=\"#{classes.join(' ')}\"" unless classes.empty?
    open_tag += ">\n"
    open_tag
  end
end