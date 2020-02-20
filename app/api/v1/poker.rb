require 'grape'
module API
  module V1
    class Poker < Grape::API
      # helpers do
      #   include CommonActions
      # end
      content_type :json, 'application/json'
      format :json
      params do
        requires :cards, type: Array
      end
      post 'cards/check' do
        results = []
        params[:cards].each do |card|
          result = {}
          result[:card] = card
          results << card
        end
        if results.present?
          {
              "result":
                  results.each do |result|
                    {
                        "card": result[:card]
                    }
                  end,
          }
        end
      end
    end
  end
end
