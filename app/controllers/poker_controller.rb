class PokerController < ApplicationController
  include CommonActions

  def index

  end

  def judge
    @cards = poker_params
    @card = @cards.split(' ')
    if correct_blank?(@cards) == false
      flash.now[:alert] = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
      render "index" and return
    end
    error_messages = {}
    if correct_cards?(@cards, error_messages) == false
      error_sentences(error_messages)
      flash.now[:alert] = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      render "index" and return
    end
    if unique_card?(@card) == false
      flash.now[:alert] = "カードが重複しています。"
      render "index" and return
    end
    @suits = @cards.delete("^H|C|D|S| ").split(' ')
    numbers_string = @cards.delete("^0-9| ").split(' ')
    @numbers = numbers_string.map!(&:to_i)
    @number_counter = []
    for i in 0..@numbers.uniq.length-1
      @number_counter[i] = @numbers.count(@numbers.uniq[i])
    end
    @sorted_number_counter = @number_counter.sort.reverse
    @result = judge_cards(@sorted_number_counter, @suits, @numbers)
    render "index" and return
  end

  private
  def poker_params
    params[:cards]
  end

end
