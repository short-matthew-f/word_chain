class Node
  def initialize(value)
    @value = value
    @children = []
    @parent = nil
  end

  def value
    @value
  end

  def children
    @children
  end

  def parent
    @parent
  end

  def add_child(child_node)
    child_node.parent = self unless children.include?(child_node)

    child_node
  end

  def remove_child(child_node)
    child_node.parent = nil
  end

  def path_to_root
    path = [self]
    current_node = self

    loop do
      break if current_node.parent == nil
      current_node = current_node.parent
      path.unshift(current_node)
    end

    path
  end

  def parent=(parent_node)
    if self.parent
      self.parent.children.delete(self)
    end

    @parent = parent_node
    self.parent.children << self unless self.parent.nil?

    self
  end


  def dfs(value)
    return self if self.value == value

    self.children.each do |child|
      result = child.dfs(value)
      return result unless result.nil?
    end

    nil
  end

  def bfs(value)
    @queue = [self]
    until @queue.empty?
      suspect = @queue.shift
      if suspect.value == value
        return suspect
      else
        @queue += suspect.children
      end
    end
  end
end