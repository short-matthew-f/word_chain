require './node.rb'

class WordChainer
  attr_accessor :start_word, :working_words, :root

  def initialize(start_word)
    @start_word = start_word
    @working_words = create_dictionary.select { |word| word.length == start_word.length }
    @root = build_tree
  end


  # here we build an entire tree for the input word.  
  # this is inefficient when we're just searching for a specific word
  # path, but it allows us to search for any word path once it's over
  def build_tree
    root = Node.new(start_word)
    node_queue = [root]

    until node_queue.empty? || self.working_words.empty?
      current_node = node_queue.shift
      current_word = current_node.value

      neighbors = adjacent_words(current_word, self.working_words)

      neighbors.each do |word|
        node_queue << current_node.add_child(Node.new(word))
      end

      self.working_words -= neighbors
    end

    root
  end

  def create_dictionary
    File.readlines('dictionary.txt').map(&:chomp)
  end

  def adjacent_words(in_word, word_list)
    word_list.select { |word| are_adjacent?(in_word, word) }
  end

  def are_adjacent?(word_1, word_2)
    return false if word_1.length != word_2.length

    (0...word_1.length).map do |i|
      word_1[i] == word_2[i]
    end.select do |t|
      t == false
    end.count == 1
  end

  # chain to 'pretty-prints' our word chains
  def chain_to(end_word)
    end_node = @root.dfs(end_word)
    if end_node
      end_node.path_to_root.map { |node| node.value }.join(" => ")
    else
      nil
    end
  end
end