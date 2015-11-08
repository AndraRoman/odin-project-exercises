def bubble_sort(array)
  temp = array.clone
  finished = false

  until finished
    finished = pass!(temp)
  end

  temp
end

def pass!(array)
  unsorted = false
  array.each.with_index(1) do |i, index|
    if index + 1 <= array.length && i > array[index] # index is of second elt of pair
      unsorted = true
      array[index - 1] = array[index]
      array[index] = i
    end
  end
  !unsorted
end

# takes a block
def bubble_sort_by(array)
  temp = array.clone
  finished = false

  until finished
    finished = true
    temp.each.with_index(1) do |i, index|
      if index + 1 <= temp.length
        comparison = yield(i, temp[index])
        if comparison > 0
          finished = false
          temp[index - 1] = temp[index]
          temp[index] = i
        end
      end
    end
  end

  temp
end
