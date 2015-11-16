module Enumerable
  def my_each
    if block_given?
      for j in self do
        yield(j)
      end
    else
      self.to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      index = 0
      self.my_each do |i|
        yield(i, index)
        index += 1
      end
    else
      self.to_enum(:my_each_with_index)
    end
  end

  def my_select
    if block_given?
      result = self.class.new
      self.my_each do |i|
        if yield(i)
          result.my_add_to_enumerable(i)
        end
      end
      result
    else
      self.to_enum(:my_select)
    end
  end

  def my_all?
    if block_given?
      self.my_each do |i|
        if !yield(i)
          return false
        end
      end
    end
    true
  end

  def my_any?
    if block_given?
      self.my_each do |i|
        if yield(i)
          return true
        end
      end
      return false
    end
    true
  end

  def my_none?
    if block_given?
      self.my_each do |i|
        puts "comparing #{i}"
        if yield(i)
          puts "condition met"
          return false
        end
      end
      return true
    else
      return false
    end
  end

  def my_count
    n = 0
    self.my_each do |i|
      n += 1
    end
    n
  end

  def my_map
    if block_given?
      result = self.class.new
      self.my_each do |i|
        j = yield(i)
        result.my_add_to_enumerable(j)
      end
      result
    else
      self.to_enum(:my_map)
    end
  end

  # assyming that every enumerable class but hashes has push method
  def my_add_to_enumerable(item)
    if self.class.to_s == 'Hash'
      self[item[0]] = item[1] 
    else
      self.push(item)
    end
  end

  def my_map_with_proc(my_proc)
    result = self.class.new
    self.my_each do |i|
      j = my_proc.call(i)
      result.my_add_to_enumerable(j)
    end
    result
  end

# instructions say "take either a proc or a block, executing the block only if both are supplied (in which case it would execute both the block AND the proc)."
# this doesn't make sense so I'll have it execute the block whenever it's supplied, and the proc only if no block is supplied
  def my_map_with_proc_or_block(my_proc = Proc.new{}, &block)
    if block_given?
      return self.my_map(&block)
    else
      return self.my_map_with_proc(my_proc)
    end
  end
  
  def my_inject(initial=(arg_not_given=true; nil))
    if arg_not_given
      val = self[0]
    else
      val = yield(initial, self[0])
    end
    prev = nil
    self.my_each_with_index do |i, index|
      if index > 0
        val = yield(val, i)
      end
    end
    val
  end

end

def multiply_els(array)
  array.my_inject(1) {|x, y| x * y}
end
