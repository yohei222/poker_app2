module V1
  class Root < Grape::API
    # これでdomain/api/v1でアクセス出来るようになる。(versioning)
    version 'v1', using: :path
    format :json
    mount V1::Poker
  end
end
