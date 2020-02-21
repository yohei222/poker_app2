module API
  module V1
    class Poker < Grape::API
      helpers do
        include CommonActions
      end
      content_type :json, 'application/json'
      format :json
      params do
        requires :cards, type: Array
      end
      post 'cards/check' do
        results = []
        errors = []
        params[:cards].each do |card|
          @suits = card.delete("^H|C|D|S| ").split(' ')
          numbers_string = card.delete("^0-9| ").split(' ')
          @numbers = numbers_string.map!(&:to_i)
          for i in 0..@numbers.uniq.length-1
            @number_counter[i] = @numbers.count(@numbers.uniq[i])
          end
          @sorted_number_counter = @number_counter.sort.reverse
          @results = hash_result(results, card, @sorted_number_counter, @suits, @numbers)
        end
      end
      if @results.present?
        {
            "result":
                @results.each do |result|
                  {
                      "card": result[:card],
                      "hand": result[:hand]
                  }
                end
        }
      end
    end
  end
end
