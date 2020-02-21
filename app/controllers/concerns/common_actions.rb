module CommonActions
  extend ActiveSupport::Concern

  def get_card(cards)
    cards.split(' ')
  end

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
    end
    return number_counter.sort.reverse
  end

  def correct_blank?(cards)
    cards.match(/\A([^\s\p{blank}]+ ){4}[^\s\p{blank}]+$/).nil? ? false : true
  end

  def correct_cards?(cards, error_messages)
    cards.split(' ').each.with_index(1) do |card, i|
      correct_card = card.match(/\A[SHCD]([1][0-3]|[1-9])$/)
      if correct_card.nil?
        error_messages[i] = "#{i}番目のカード指定文字が不正です。（#{card})"
      end
    end
    if error_messages.present?
      return false
    else
      return true
    end
  end

  def error_sentences(error_messages)
    error_messages.values.each_with_index do |error_message, i|
      flash.now[i] = error_message
    end
  end

  def unique_card?(card)
    card.uniq.length == 5 ? true : false
  end

  def straight?(numbers)
    (numbers.sort[0] + 1 == numbers.sort[1] && numbers.sort[1] + 1 == numbers.sort[2] && numbers.sort[2] + 1 == numbers.sort[3] && numbers.sort[3] + 1 == numbers.sort[4]) || numbers.sort == [1,10,11,12,13] ? true : false
  end

  def flush?(suits)
    (suits.count(suits[0]) == suits.length) ? true : false
  end

  def judge_cards(sorted_number_counter, suits, numbers)
    if sorted_number_counter == [4,1]
      judge = "Four Card"
    elsif sorted_number_counter == [3,2]
      judge = "Full House"
    elsif sorted_number_counter == [3,1,1]
      judge = "Three Card"
    elsif sorted_number_counter == [2,2,1]
      judge = "Two Pair"
    elsif sorted_number_counter == [2,1,1,1]
      judge = "One Pair"
    else sorted_number_counter == [1,1,1,1,1]
      if straight?(numbers) && flush?(suits)
        judge = "Straight Flush"
        elsif straight?(numbers)
        judge = "Straight"
        elsif flush?(suits)
        judge = "Flush"
        else
        judge = "High Card"
      end
    end
  end

  def evaluate_cards(result)
    if result == "Straight Flush"
      rank = 1
    elsif result == "Four Card"
      rank = 2
    elsif result == "Full House"
      rank = 3
    elsif result == "Flush"
      rank = 4
    elsif result == "Straight"
      rank = 5
    elsif result == "Three Card"
      rank = 6
    elsif result == "Two Pair"
      rank = 7
    elsif result == "One Pair"
      rank = 8
    elsif result == "High Card"
      rank = 9
    else
      rank = nil
    end
  end

end
