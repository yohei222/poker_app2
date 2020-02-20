require 'grape'
class Base < Grape::API
  version 'v1'
  # content_type :json, 'application_json'
  # format :json
  # get 'cards/check' do
  #   { hello: 'world' }
  # end
  helpers do
    include CommonActions
  end
  content_type :json, 'application/json'
  format :json
  params do
    requires :cards, type: Array
  end
  post 'cards/check' do
    @results = []
    #:cardsは"H1 H13 H12 H11 H10"の組み合わせが３つ(例)
    # cardsは"H1 H13 H12 H11 H10"(例)
    params[:cards].each do |cards|
      result = {}
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
      @results << result
    end
    if @results.present?
      {
          "result":
              @results.each do |result|
                # binding.pry
                {
                    "card": result[:card],
                    "hand": result[:judge]
                }
              end,
      }
    end
    # binding.pry
  end

  # mount V1::Base
end
