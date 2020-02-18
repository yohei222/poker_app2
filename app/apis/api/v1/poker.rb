module API
  module V1
    class Poker < Grape::API
      helpers do
        include CommonActions
      end
      format :json
      content_type :json, 'application/json'
      version 'v1', using: :path
      params do
        requires :cards, type: Array
      end

      post 'check' do

      end

    end
  end
end
