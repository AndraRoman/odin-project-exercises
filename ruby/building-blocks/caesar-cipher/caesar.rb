def caesar_cipher(str, shift)
  temp = str.split('').map do |char|
    n = char.ord
    if letter?(n)
      add_c(n, shift)
    else char
    end
  end
  temp.join('')
end

def letter? n
  (n >= 65 && n <= 90) || (n >= 97 && n <= 122)
end

def capital? n
  n < 95
end

def add_c (n, shift)
  if capital?(n)
    base_shift = 65
  else
    base_shift = 97
  end
  m = ((n - base_shift) + shift) % 26
  (m + base_shift).chr
end
