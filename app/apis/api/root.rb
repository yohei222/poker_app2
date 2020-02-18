require 'grape'
module API
  class Root < Grape::API
    prefix 'api/'
    version 'v1', using: :path
    format :json
    mount API::V1::Poker
  end
end
