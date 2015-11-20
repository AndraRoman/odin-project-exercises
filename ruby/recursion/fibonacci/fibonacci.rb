def fibs(n)
  result = []
  while n > 0
    if result.length < 2
      result.push(1)
    else
      result.push(result[-1] + result[-2])
    end
    n -= 1
  end
  result
end

def fibs_rec(n)
  if n <= 2
    Array.new(n, 1)
  else
    prev = fibs_rec(n - 1)
    prev.push(prev[-1] + prev[-2])
  end
end
