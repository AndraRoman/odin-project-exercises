def merge_sort(list)
  if list.length <= 1
    list
  else
    center = list.length / 2
    left = list[0...center]
    right = list[center..-1]
    merge_two_sorted_lists(merge_sort(left), merge_sort(right))
  end
end

def merge_two_sorted_lists(x, y)
  result = []
  if x == []
    result = y
  elsif y == []
    result = x
  elsif x[0] <= y[0]
    result.push(x[0])
    result += merge_two_sorted_lists(x[1..-1], y)
  else
    result.push(y[0])
    result += merge_two_sorted_lists(x, y[1..-1])
  end
end
