class Base < Grape::API
  format :json
  prefix "api"
  version 'v1', using: :path
  params do
    requires :cards, type: Array
  end
  desc 'return cards'
  post 'cards/check' do
    params[:cards].each do |card|
      {
          "card": card
      }
    end
  end
end
