require 'grape'
class Base < Grape::API
  version 'v1'
  helpers do
    include CommonActions
  end
  content_type :json, 'application/json'
  format :json
  params do
    requires :cards, type: Array
  end
  post 'cards/check' do
    @errors = []
    @results = []
    #:cardsは"H1 H13 H12 H11 H10"の組み合わせが３つ(例)
    # cardsは"H1 H13 H12 H11 H10"(例)
    params[:cards].each do |cards|
      errors = {}
      if correct_blank?(cards) == false
        error = {}
        error[:card] = cards
        error[:msg] = '5つのカード指定文字を半角スペース区切りで入力してください。'
        @errors << error
        next
      end
      error_messages = {}
      # if correct_cards?(cards, error_messages) == false
      #   error = {}
      #   error_messages.values.each do |msg|
      #     error[:card] = cards
      #     error[:msg] = msg
      #     @errors << error
      #   end
      #   next
      # end

      @card_for_validation = cards.split(' ')
      if unique_card?(@card_for_validation) == false
        error = {}
        error[:card] = cards
        error[:msg] = 'カードが重複しています。'
        @errors << error
        next
      end

      result = {}
      messages = {}
      result[:card] = cards
      @cards = cards
      @card = @cards.split(' ')
      @suits = @cards.delete("^H|C|D|S| ").split(' ')
      numbers_string = @cards.delete("^0-9| ").split(' ')
      @numbers = numbers_string.map!(&:to_i)
      @number_counter = []
      for i in 0..@numbers.uniq.length-1
        @number_counter[i] = @numbers.count(@numbers.uniq[i])
      end
      @sorted_number_counter = @number_counter.sort.reverse
      @result = judge_cards(@sorted_number_counter, @suits, @numbers)
      result[:judge] = @result
      result[:rank] = evaluate_cards(@result)
      @results << result
    end
    rank_numbers = []
    for i in 0..@results.size-1
      rank_numbers << @results[i][:rank]
    end
    @strongest_number = rank_numbers.min
    if @results.present?
      @results.each do |result|
        if @strongest_number == result[:rank]
          result[:best] = true
        else
          result[:best] = false
        end
        result.delete(:rank)
      end
    end

    # if @results.present?
    #   {
    #       "result":
    #           @results.each do |result|

    #             {
    #                 "card": result[:card],
    #                 "hand": result[:judge],
    #                 "best": result[:best]
    #             }
    #           end,
    #   }
    # end
    if @results.present? && @errors.present?
      {
          "result":
              @results.each do |result|
                {
                    "card": result[:card],
                    "hand": result[:judge],
                    "best": result[:best]
                }
              end,
          "errors":
              @errors.each do |error|
                {
                    "card": error[:card],
                    "msg": error[:msg]
                }
              end
      }
    elsif @results.present?
      {
          "result":
              @results.each do |result|
                {
                    "card": result[:card],
                    "hand": result[:judge],
                    "best": result[:best]
                }
              end
      }
    elsif @errors.present?
      {
          "errors":
              @errors.each do |error|
                {
                    "card": error[:card],
                    "msg": error[:msg]
                }
              end
      }
    end
  end
  # mount V1::Base
end
