module API
  module V1
    class Base < Grape::API
      # http://localhost:3000/api/v1/
      version 'v1', using: :path
      format :json

      mount  V1::Poker
    end
  end
end
