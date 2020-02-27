module PokerMethods
  extend ActiveSupport::Concern

  def get_suits(cards)
    cards.delete("^H|C|D|S| ").split(' ')
  end

  def get_numbers(cards)
    numbers_string = cards.delete("^0-9| ").split(' ')
    return numbers_string.map!(&:to_i)
  end

  def number_counter(numbers, number_counter)
    for i in 0..numbers.uniq.length-1
      number_counter[i] = numbers.count(numbers.uniq[i])
      # numbers = [10,10,11,12,13]であるとき
      # numbers.uniq => [10, 11, 12, 13] numbers.uniq[0] = 10
    end
    return number_counter.sort.reverse
    #今回だと number_counter.sort.reverse = [2,1,1,1]
  end

  def straight?(numbers)
    (numbers.sort[0] + 1 == numbers.sort[1] && numbers.sort[1] + 1 == numbers.sort[2] && numbers.sort[2] + 1 == numbers.sort[3] && numbers.sort[3] + 1 == numbers.sort[4]) || numbers.sort == [1,10,11,12,13] ? true : false
  end

  def flush?(suits)
    (suits.count(suits[0]) == suits.length) ? true : false
  end

  def judge_cards(sorted_number_counter, suits, numbers)
    if sorted_number_counter == [4,1]
      "フォー・オブ・ア・カインド"
    elsif sorted_number_counter == [3,2]
      "フルハウス"
    elsif sorted_number_counter == [3,1,1]
      "スリー・オブ・ア・カインド"
    elsif sorted_number_counter == [2,2,1]
      "ツーペア"
    elsif sorted_number_counter == [2,1,1,1]
      "ワンペア"
    else sorted_number_counter == [1,1,1,1,1]
      if straight?(numbers) && flush?(suits)
        "ストレートフラッシュ"
      elsif flush?(suits)
        "フラッシュ"
      elsif straight?(numbers)
        "ストレート"
      else
        "ハイカード"
      end
    end
  end

  def get_result(cards)
    suits = get_suits(cards)
    numbers = get_numbers(cards)
    number_counter = []
    sorted_number_counter = number_counter(numbers, number_counter)
    @result = judge_cards(sorted_number_counter, suits, numbers)
  end

  def evaluate_cards(result)
    if result == "ストレートフラッシュ"
      1
    elsif result == "フォー・オブ・ア・カインド"
      2
    elsif result == "フルハウス"
      3
    elsif result == "フラッシュ"
      4
    elsif result == "ストレート"
      5
    elsif result == "スリー・オブ・ア・カインド"
      6
    elsif result == "ツーペア"
      7
    elsif result == "ワンペア"
      8
    elsif result == "ハイカード"
      9
    else
      nil
    end
  end

end
