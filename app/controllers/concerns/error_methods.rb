module ErrorMethods
  extend ActiveSupport::Concern
  include PokerMethods

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

  def unique_card?(cards)
    card = cards.split(' ')
    card.uniq.length == 5 ? true : false
  end

end
