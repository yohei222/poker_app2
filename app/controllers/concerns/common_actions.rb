module CommonActions
  extend ActiveSupport::Concern

  def correct_cards?(cards)
    cards.match(/^([SHCD]([1][0-3]|[1-9])+ ){4}[SHCD]([1][0-3]|[1-9])$/).nil? ? false : true
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
end
