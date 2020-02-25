require 'grape'
class Base < Grape::API
  version 'v1'
  helpers do
    include CommonActions
    def params_error!
      error!({"error":[{"msg":"不正なリクエストです。"}]}, 400, { 'Content-Type' => 'application/json' })
    end
  end
  format :json
  params do
    requires :cards, type: Array
  end
  rescue_from :all do |e|
    params_error!
  end
  post 'cards/check' do
    @errors = []
    @results = []
    if params[:cards].nil?
      params_error!
    end
    params[:cards].each do |cards|
      if correct_blank?(cards) == false
        error = {}
        error[:card] = cards
        error[:msg] = '5つのカード指定文字を半角スペース区切りで入力してください。'
        @errors << error
        next
      end

      error_messages = []
      if correct_cards?(cards, error_messages) == false
        error_messages.delete(nil)
        @error_messages = error_messages
        @error_messages.each do |msg|
          error = {}
          error[:card] = cards
          error[:msg] = msg
          @errors << error
        end
        next
      end

      @card_for_validation = get_card(cards)
      if unique_card?(@card_for_validation) == false
        error = {}
        error[:card] = cards
        error[:msg] = 'カードが重複しています。'
        @errors << error
        next
      end

      result = {}
      result[:card] = cards
      @cards = cards
      @card = get_card(@cards)
      @suits = get_suits(@cards)
      @numbers = get_numbers(@cards)
      @number_counter = []
      @sorted_number_counter = number_counter(@numbers, @number_counter)
      @result = judge_cards(@sorted_number_counter, @suits, @numbers)
      result[:hand] = @result
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

    if @results.present? && @errors.present?
      {
          "result":
              @results.each do |result|
                {
                    "card": result[:card],
                    "hand": result[:hand],
                    "best": result[:best]
                }
              end,
          "error":
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
                    "hand": result[:hand],
                    "best": result[:best]
                }
              end
      }
    elsif @errors.present?
      {
          "error":
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
