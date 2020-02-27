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
      judge = "フォー・オブ・ア・カインド"
    elsif sorted_number_counter == [3,2]
      judge = "フルハウス"
    elsif sorted_number_counter == [3,1,1]
      judge = "スリー・オブ・ア・カインド"
    elsif sorted_number_counter == [2,2,1]
      judge = "ツーペア"
    elsif sorted_number_counter == [2,1,1,1]
      judge = "ワンペア"
    else sorted_number_counter == [1,1,1,1,1]
      if straight?(numbers) && flush?(suits)
        judge = "ストレートフラッシュ"
      elsif flush?(suits)
        judge = "フラッシュ"
      elsif straight?(numbers)
        judge = "ストレート"
      else
        judge = "ハイカード"
      end
    end
  end

  def evaluate_cards(result)
    if result == "ストレートフラッシュ"
      rank = 1
    elsif result == "フォー・オブ・ア・カインド"
      rank = 2
    elsif result == "フルハウス"
      rank = 3
    elsif result == "フラッシュ"
      rank = 4
    elsif result == "ストレート"
      rank = 5
    elsif result == "スリー・オブ・ア・カインド"
      rank = 6
    elsif result == "ツーペア"
      rank = 7
    elsif result == "ワンペア"
      rank = 8
    elsif result == "ハイカード"
      rank = 9
    else
      rank = nil
    end
  end


  # @resultまで一気に返ってくるメソッドを作成する
  def get_result(cards)
    suits = get_suits(cards)
    numbers = get_numbers(cards)
    number_counter = []
    sorted_number_counter = number_counter(numbers, number_counter)
    @result = judge_cards(sorted_number_counter, suits, numbers)
  end

end
