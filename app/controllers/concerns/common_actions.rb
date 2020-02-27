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
      # numbers = [10,10,11,12,13]であるとき
      # numbers.uniq => [10, 11, 12, 13] numbers.uniq[0] = 10
    end
    return number_counter.sort.reverse
    #今回だと number_counter.sort.reverse = [2,1,1,1]
  end

  def correct_blank?(cards)
    #\Aはファイルの文頭、という意味
    #\zはファイルの文末、という意味
    #+は直前の文字の1回以上の繰り返し、という意味
    #\A([^\s\p{blank}]+ は、(半角スペース、タブ、改行のどれか1文字(\s)あるいは全角スペース(\p{blank})以外の文字+半角スペース)
    cards.match(/\A([^\s\p{blank}]+ ){4}[^\s\p{blank}]+\z/).nil? ? false : true
  end

  def correct_cards?(cards, error_messages)
    #@cardsにするとviewに配列が帰ってきてしまうため、@array_cardsを用いる
    # #@array_cards => ["S10", "H11", "H12", "H13", "H15"]
    @array_cards = get_card(cards)
    @array_cards.each.with_index(1) do |card, i|
      correct_card = card.match(/\A[SHCD]([1][0-3]|[1-9])$/)
      if correct_card.nil?
        error_messages[i] = "#{i}番目のカード指定文字が不正です。（#{card})"
        # error_messages => {5=>"5番目のカード指定文字が不正です。（H15)"}
      end
    end
    if error_messages.present?
      return false
    else
      return true
    end
  end

  def insert_flash(error_messages)
    # error_messages => {5=>"5番目のカード指定文字が不正です。（H15)"}
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

end
