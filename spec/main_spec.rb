require 'spec_helper'
require 'pry'

=begin
(a[:len(a)//2], a[len(a)//2], a[len(a)//2+1:])
=end

class Node
  attr_reader :keys, :children

  def initialize(keys: [], children: [])
    @keys = keys
    @children = children
  end

  def search(search_key)
    return self if @keys.include?(search_key)

    keys_and_children do |node_key, node_child|
      if search_key_is_in_child?(search_key, node_key)
        return node_child.search(search_key)
      end
    end

    @children.last&.search(search_key)
  end




  private
  def keys_and_children
    @keys.zip(@children)
  end

  def search_key_is_in_child?(search_key, node_key)
    search_key < node_key
  end
end

class Tree
  def initialize(root_node: Node.new)
    @root_node = root_node
  end

  def search(search_key)
    @root_node.search(search_key)
  end
end

describe 'btree' do
  it 'if the key is not found return nil' do
    tree = Tree.new
    expect(tree.search(2)).to eq(nil)
  end

  context 'with a btree that has 1 node and 3 children btree' do
    it 'if the key is not found return nil' do
      tree = Tree.new(root_node: Node.new(children: [Node.new(keys: [1])]))
      expect(tree.search(2)).to eq(nil)
    end

    it 'can find an item with one key and a depth of 1' do
      number = rand(100)
      root_node = Node.new(keys: [number])
      tree = Tree.new(root_node: root_node)
      expect(tree.search(number)).to eq(root_node)
    end

    it 'can find an item on the leftmost node with a depth of 2' do
      child_node = Node.new(keys: [1])
      root_node = Node.new(keys: [3,30], children: [child_node])
      tree = Tree.new(root_node: root_node)
      expect(tree.search(1)).to eq(child_node)
    end

    it 'can find an item in the right most node' do
      child_node = Node.new(keys: [99])
      root_node = Node.new(keys: [1,90], children: [nil, nil, child_node])
      tree = Tree.new(root_node: root_node)
      expect(tree.search(99)).to eq(child_node)
    end

    it 'can find a item in a middle node' do
      child_node = Node.new(keys: [50])
      root_node = Node.new(keys: [1,90], children: [nil, child_node, nil])
      tree = Tree.new(root_node: root_node)
      expect(tree.search(50)).to eq(child_node)
    end
  end

  it 'can recursivly find items' do
    leaf_node = Node.new(keys: [50])
    internal_node_1= Node.new(keys: [51,90], children: [leaf_node, nil, nil])
    root_node = Node.new(keys: [1,90], children: [nil, internal_node_1, nil])
    tree = Tree.new(root_node: root_node)
    expect(tree.search(50)).to eq(leaf_node)
  end
end
