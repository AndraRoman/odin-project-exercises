# dictionary is an array of valid substrings
# returns hash listing each of these substrings (case insensitive) found in word and how many times it was found
# warning: only works for ASCII characters

# Rabin-Karp algorithm

def substrings(word, dictionary)
  matches = {}
  dictionary.each {|key| matches[key.downcase] = 0}

  word_as_nums = string_to_nums(word)
  prime = 103 # arbitrary
  split_dictionary = dictionary.group_by {|x| x.length}

  split_dictionary.each do |length, dictionary_partial|
    matches_partial = substrings_for_fixed_length(word_as_nums, dictionary_partial, prime)
    matches = merge_matches(matches, matches_partial)
  end

  matches
end

def string_to_nums(str)
  str.split("").map {|c| c.downcase.ord}
end

def fingerprint(array, prime)
  result = 0
  exp = array.length - 1

  array.each do |i|
    result = result + i * (prime ** exp)
    exp = exp - 1
  end

  result
end

def make_dictionary_hash(dictionary, prime)
  result = {}
  dictionary.each do |i|
    array = string_to_nums(i)
    fingerprint = fingerprint(array, prime)
    if result[fingerprint].nil? # if there's no collision
      result[fingerprint] = [[i.downcase, array]]
    else
      result[fingerprint] = result[fingerprint] + [[i.downcase, array]]
    end
  end
  result
end

def roll(fingerprint, first, next_elt, exp, prime)
  hash = fingerprint - (first * (prime ** exp)) # remove first element
  hash = (hash * prime) + next_elt # add next element
  hash
end

# takes array of integers, array of substrings
# returns a match hash
def substrings_for_fixed_length(word_as_nums, dictionary, prime)
    length = dictionary[0].length
    current_fingerprint = fingerprint(word_as_nums[0...length], prime)
    index = 0
    dictionary_hash = make_dictionary_hash(dictionary, prime)

    matches = {}
    dictionary.each {|key| matches[key.downcase] = 0}
    loop do
      if !dictionary_hash[current_fingerprint].nil?
        current_array = word_as_nums[index...index + length]
        dictionary_hash[current_fingerprint].each do |w|
          if w[1] == current_array
            matches[w[0]] = matches[w[0]] + 1
          end
        end
      end
      index = index + 1
      if index > word_as_nums.length - length
        break 
      end
      current_fingerprint = roll(current_fingerprint, word_as_nums[index - 1], word_as_nums[index + length - 1], length - 1, prime)
    end
    matches
end

# returns a new combined match table - does not mutate final
def merge_matches(full, partial)
  matches = full.clone

  partial.each do |key, value|
    initial_val = 0
    if !full[key].nil?
      initial_val = full[key]
    end
    matches[key] = initial_val + value
  end

  matches
end

def naive_substrings(word, dictionary)
  matches = {}
  word_as_array = word.downcase.split("")
  dictionary.each {|key| matches[key.downcase] = 0}
  dictionary.each do |key|
    matches[key.downcase] += naive_single_substring(word_as_array, key.downcase.split(""))
  end
  matches
end

# word and substring are both arrays of letters
def naive_single_substring(word, substring)
  match_count = 0
  matches_in_progress = [-1] 
  word.each do |letter|
    temp_matches_in_progress = [-1]
    matches_in_progress.each_with_index do |n, index|
      if letter == substring[n + 1]
        if n + 1 == substring.length - 1
          match_count += 1
        else
          temp_matches_in_progress.push(n + 1)
        end
      end
    end
    matches_in_progress = temp_matches_in_progress
  end
  match_count
end
