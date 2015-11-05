# takes array of stock prices in chronological order
# returns pair of indices (buy date and sell date) giving most profit
# NO SHORTING
def stock_picker(prices)

  min_so_far = { :price => [prices[0], prices[1]].min }
  min_so_far[:position] = prices.index(min_so_far[:price])

  best_so_far = { :first_index => 0, :second_index => 1, :profit => prices[1] - prices[0] }

  current_position = 1
  
  prices[2..-1].each do |price|
    current_position += 1
    if price < min_so_far[:price]
      min_so_far[:price] = price
      min_so_far[:position] = current_position
    else
      profit = price - min_so_far[:price]
      if profit > best_so_far[:profit]
        best_so_far[:first_index] = min_so_far[:position]
        best_so_far[:second_index] = current_position
        best_so_far[:profit] = profit
      end
    end
  end

  [best_so_far[:first_index], best_so_far[:second_index]]

end
