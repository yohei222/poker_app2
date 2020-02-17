class PokerController < ApplicationController
  include CommonActions

  def index

  end

  def judge
    @cards = poker_params
    @card = @cards.split(' ')
    if correct_cards?(@cards) == false or unique_card?(@card) == false
      flash.now[:alert] = "※H,S,D,Cと1~13の数字の組み合わせで入力してください。カード間には半角スペースを入力してください。"
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
