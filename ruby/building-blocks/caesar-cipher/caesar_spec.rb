require 'caesar'

describe "letter?" do
  it "returns true for the ASCII value of a letter" do
    expect(letter?("a".ord)).to be(true)
    expect(letter?("Z".ord)).to be(true)
  end

  it "returns false otherwise" do
    expect(letter?(64)).to be(false)
    expect(letter?(91)).to be(false)
    expect(letter?(123)).to be(false)
  end

end

describe "capital?" do
  it "returns true for ASCII value of a capital letter" do
    expect(capital?("Z".ord)).to be(true)
    expect(capital?("A".ord)).to be(true)
  end

  it "returns false for ASCII value of a lowercase letter" do
    expect(capital?("a".ord)).to be(false)
    expect(capital?("z".ord)).to be(false)
  end
end

describe "add_c" do
  it "takes an ASCII letter value and returns the ciphered letter" do
    expect(add_c("a".ord, 11)).to eq("l")
    expect(add_c("y".ord, 3)).to eq("b")
    expect(add_c("A".ord, 11)).to eq("L")
    expect(add_c("Y".ord, 3)).to eq("B")
  end
end

describe "caesar_cipher" do
  it "applies caesar cipher with a specified offset" do
    expect(caesar_cipher("THE quick BROWN fox JUMPED over THE lazy DOG.", 4)).to eq("XLI uymgo FVSAR jsb NYQTIH sziv XLI pedc HSK.")
  end
end
