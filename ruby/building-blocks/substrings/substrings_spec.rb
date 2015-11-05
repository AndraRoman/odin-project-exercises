require "substrings"

describe "string_to_nums" do
  it "handles mixture of cases" do
    string = "Hello, World!"
    array = string_to_nums(string)
    expected_result = [104, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33]
    expect(array).to eq(expected_result)
  end
end

describe "make_dictionary_hash" do
  it "is case insensitive" do
    dictionary = ["One", "tWo", "tHREe"]
    prime = 97
    hash = make_dictionary_hash(dictionary, prime)
    expected_result = {
      1055170     => [["one", [111, 110, 101]]],
      1103098     => [["two", [116, 119, 111]]],
      10365397112 => [["three", [116, 104, 114, 101, 101]]]
    }
    expect(hash).to eq(expected_result)
  end

  it "handles hash collisions" do
    prime = 2
    dictionary = ["d2", "c4", "b6"] # all have fingerprint of 250
    hash = make_dictionary_hash(dictionary, prime)
    expected_result = {
      250 => [["d2", [100, 50]], ["c4", [99, 52]], ["b6", [98, 54]]]
    }
    expect(hash).to eq(expected_result)
  end
end

describe "merge_matches" do
  it "combines two match hashes" do
    partial = {1 => 0, 2 => 4, 3 => 1, 5 => 2}
    full = {1 => 5, 2 => 1, 3 => 0, 6 => 3}
    matches = merge_matches(full, partial)
    expected_result = {1 => 5, 2 => 5, 3 => 1, 5 => 2, 6 => 3}
    expect(matches).to eq(expected_result)
  end
end

describe "fingerprint" do
  it "calculates Rabin fingerprint correctly" do
    array = [3, 5, 20, 11, 0]
    prime = 107
    fingerprint = fingerprint(array, prime)
    expect(fingerprint).to be 399594175
  end

  it "and does the same for another array and prime" do
    array = [97, 98, 114]
    prime = 101
    fingerprint = fingerprint(array, prime)
    expect(fingerprint).to be 999509
  end
end

describe "roll" do
  it "calculates new fingerprint given old fp, element being removed, and element being added" do
    fingerprint = 999509
    first = 97
    new = 97
    exp = 2
    prime = 101
    new_fingerprint = roll(fingerprint, first, new, exp, prime)
    expect(new_fingerprint).to be 1011309
  end
end

describe "substrings_for_fixed_length" do
  it "finds subarrays matching a dictionary with fixed word length" do
    array = [98, 97, 110, 97, 110, 97, 110, 97, 110, 97] # "banananana"
    dictionary = ["nan", "ana", "ban", "xxx"]
    prime = 101
    matches = substrings_for_fixed_length(array, dictionary, prime)
    expected_result = {"nan" => 3, "ana" => 4, "ban" => 1, "xxx" => 0}
    expect(matches).to eq(expected_result)
  end
 
  it "should handle hash collisions" do
    prime = 3
    array = [101, 108, 121, 101, 108, 121, 101, 110, 101, 109, 117, 117, 101, 110, 114, 101, 120, 101, 120, 120, 120, 120, 101, 120, 120, 120, 101] # "elyelyenemuuenrexexxxxexxxe"
    dictionary = ["elye", "enre", "emue", "xxxx"] # first three have same fingerprint
    matches = substrings_for_fixed_length(array, dictionary, prime)
    expected_result = {"elye" => 2, "enre" => 1, "emue" => 0, "xxxx" => 1}
    expect(matches).to eq(expected_result)
  end
end

describe "substrings" do
  it "should handle strings of different lengths" do
    word = "Thequickbrownfoxjumpedoverthelazydog!"
    dictionary = ["the", "d", "brown", "ww"]
    matches = substrings(word, dictionary)
    expected_result = {"the" => 2, "d" => 2, "brown" => 1, "ww" => 0}
    expect(matches).to eq(expected_result)
  end
end

describe "naive_single_substring" do
  it "finds matches for a single substring" do
    word = "banananana".split("")
    substring = "nan".split("")
    expect(naive_single_substring(word, substring)).to eq(3)
  end
end

describe "naive_substrings" do
  it "finds matches for a multi-word dictionary" do
    word = "Thequickbrownfoxjumpedoverthelazydog!"
    dictionary = ["the", "d", "brown", "ww"]
    matches = naive_substrings(word, dictionary)
    expected_result = {"the" => 2, "d" => 2, "brown" => 1, "ww" => 0}
    expect(matches).to eq(expected_result)
  end
end
