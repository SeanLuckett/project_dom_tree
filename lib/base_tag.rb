class BaseTag
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_html
    raise_method_error
  end

  def children?
    raise_method_error
  end

  private

  def raise_method_error
    raise BaseMethodNotImplementedError,
          'You must implement this method in your class.'
  end
end

class BaseMethodNotImplementedError < StandardError; end
