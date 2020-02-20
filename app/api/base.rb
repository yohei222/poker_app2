require 'grape'
class Base < Grape::API
  version 'v1'
  # content_type :json, 'application_json'
  # format :json
  # get 'cards/check' do
  #   { hello: 'world' }
  # end

  content_type :json, 'application/json'
  format :json
  params do
    requires :cards, type: Array
  end
  post 'cards/check' do
    @results = []
    params[:cards].each do |card|
      result = {}
      result[:card] = card
      @results << card
    end
    binding.pry
    if @results.present?
      {
          "result":
              @results.each do |result|
                {
                    "card": result
                }
              end,
      }
    end
    # { cards: params[:cards]}
  end

  # mount V1::Base
end
