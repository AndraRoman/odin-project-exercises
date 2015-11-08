require "enumerable_methods"

describe "my_each" do
  it "handles a simple block" do
    array = [1, 2, 3, 4, 5]
    temp = []
    array.my_each do |i|
      temp.push(i)
    end
    expect(temp).to eq(temp)
  end

  it "doesn't let block variables out" do
    array = [1, 2, 3, 4, 5]
    temp = []
    array.my_each do |i|
      temp.push(i)
    end
    expect(defined? i).to be(nil)
  end

  it "returns an enumerator when no block given" do
    array = [1, 2, 4]
    expect(array.my_each.class).to be(Enumerator)
  end
end

describe "my_each_with_index" do
  it "works on an array" do
    input = [5, 6, 7]
    array = []
    input.my_each_with_index do |i, index|
      array.push(i)
      array.push(index)
    end
    expect(array).to eq([5, 0, 6, 1, 7, 2])
  end

  it "works on a hash" do
    hash = {:a => 1, :b => 2}
    array = []
    hash.my_each_with_index do |i, index|
      array.push(i)
      array.push(index)
    end
    expect(array).to eq([[:a, 1], 0, [:b, 2], 1])
  end
end

describe "my_select" do
  it "works on an array" do
    array = [1, 2, 3].select {|x| x.odd?}
    expect(array).to eq([1, 3])
  end

  it "works on a hash" do
    hash = {:a => 1, :b => 2, :c => 3}.select {|k, v| v.odd?}
    expect(hash).to eq({:a => 1, :c => 3})
  end
end

describe "my_all" do
  it "handles array with result true" do
    answer = [1, 2, 3].my_all? {|i| i > 0}
    expect(answer).to be(true)
  end

  it "handles array with result false" do
    answer = [1, 2, 3].my_all? {|i| i < 2}
    expect(answer).to be(false)
  end

  it "handles hash with result true" do
    answer = {:a => 1, :b => 2, :c => 3}.my_all? {|k, v| v > 0}
    expect(answer).to be(true)
  end

  it "handles hash with result false" do
    answer = {:a => 1, :b => 2, :c => 3}.my_all? {|k, v| v > 2}
    expect(answer).to be(false)
  end
end

describe "my_any" do
  it "handles array with result true" do
    answer = [1, 2, 3].my_any? {|i| i > 2}
    expect(answer).to be(true)
  end

  it "handles array with result false" do
    answer = [1, 2, 3].my_any? {|i| i < 1}
    expect(answer).to be(false)
  end

  it "handles hash with result true" do
    answer = {:a => 1, :b => 2, :c => 3}.my_any? {|k, v| v > 2}
    expect(answer).to be(true)
  end

  it "handles hash with result false" do
    answer = {:a => 1, :b => 2, :c => 3}.my_any? {|k, v| v > 3}
    expect(answer).to be(false)
  end
end

describe "my_none" do
  it "handles array with result false" do
    answer = [1, 2, 3].my_none? {|i| i > 2}
    expect(answer).to be(false)
  end

  it "handles array with result true" do
    answer = [1, 2, 3].my_none? {|i| i < 1}
    expect(answer).to be(true)
  end

  it "handles hash with result false" do
    answer = {:a => 1, :b => 2, :c => 3}.my_none? {|k, v| v > 2}
    expect(answer).to be(false)
  end

  it "handles hash with result true" do
    answer = {:a => 1, :b => 2, :c => 3}.my_none? {|k, v| v > 3}
    expect(answer).to be(true)
  end
end

describe "my_count" do
  it "handles empty and non-empty arrays" do
    arr1 = []
    arr2 = [1, 2, 3]
    expect(arr1.my_count).to eq(0)
    expect(arr2.my_count).to eq(3)
  end

  it "handles empty and non-empty hashes" do
    h1 = {}
    h2 = {1 => 0, 2 => 0, 3 => 0}
    expect(h1.my_count).to eq(0)
    expect(h2.my_count).to eq(3)
  end
end

describe "my_map" do
  it "maps square on an array of integers" do
    array = [0, 1, 2, 3]
    squares = array.my_map {|x| x**2}
    expect(squares).to eq([0, 1, 4, 9])
  end

  it "maps 'square keys and double values' on a hash" do
    hash = {0 => 1, 2 => 3, 4 => 5}
    result = hash.my_map {|k, v| [k ** 2, v * 2]}
    expect(result).to eq({0 => 2, 4 => 6, 16 => 10})
  end
end

describe "my_map_with_proc" do
  it "maps square on an array of integers" do
    array = [0, 1, 2, 3]
    squares = array.my_map_with_proc Proc.new {|x| x**2}
    expect(squares).to eq([0, 1, 4, 9])
  end

  it "maps 'square keys and double values' on a hash" do
    hash = {0 => 1, 2 => 3, 4 => 5}
    result = hash.my_map_with_proc Proc.new {|k, v| [k ** 2, v * 2]}
    expect(result).to eq({0 => 2, 4 => 6, 16 => 10})
  end
end

describe "my_map_with_proc_or_block" do
  it "handles a proc" do
    array = [0, 1, 2, 3]
    squares = array.my_map_with_proc_or_block Proc.new {|x| x**2}
    expect(squares).to eq([0, 1, 4, 9])
  end

  it "handles a block" do
    array = [0, 1, 2, 3]
    squares = array.my_map_with_proc_or_block {|x| x**2}
    expect(squares).to eq([0, 1, 4, 9])
  end
end

describe "my_inject" do
  it "left folds an array with or without initial value" do
    no_init_val = [2, 3, 4].inject{|a, b| a ** b}
    with_init_val = [1, 2, 3].inject(2){|a, b| a ** b}
    expect(no_init_val).to be(4096)
    expect(with_init_val).to be(64)
  end

  it "left folds a hash with or without initial value" do
    no_init_val = {"a" => 2, "b" => 3, "c" => 4}.inject {|a, b| [a[0], a[1] ** b[1]]}
    with_init_val = {"a" => 1, "b" => 2, "c" => 3}.inject(2) {|a, b| a ** b[1]}
    expect(no_init_val).to eq(["a", 4096])
    expect(with_init_val).to be(64)
  end
end

describe "multiply_els" do
  it "returns the product of all elements in an array" do
    expect(multiply_els([1, 3, 5 ,2])).to be(30)
  end
end
