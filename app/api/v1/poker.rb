module V1
  class Poker < Grape::API
    helpers do
      include ErrorMethods
      include PokerMethods
      def params_error!
        error!({"error":[{"msg":"不正なリクエストです。"}]}, 400, { 'Content-Type' => 'application/json' })
      end
    end
    content_type :json, 'application/json'
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
      # params[:cards]は5枚のカード複数個の組み合わせ
      # cardsは五枚のカード1組
      params[:cards].each do |cards|
        if correct_blank?(cards) == false
          error = {}
          error[:card] = cards
          error[:msg] = '5つのカード指定文字を半角スペース区切りで入力してください。'
          @errors << error
          next
          #nextがあることで、if文に当てはまる五枚のcardsの処理は終わり、その後のメソッドの判定は表示されなくなる
          #例えば、nextがないとカードが"H1 H1 H2 H3H4"であるとき、correct_blank?で引っかかった後に、unique_card?でも引っかかるが、実際に表示したいのは最初に引っかかったvalidationのみ
          #→ここで、nextを入れることでvalidationに引っかかったcardsの処理を終了させることができる。
        end

        error_messages = []
        if correct_cards?(cards, error_messages) == false
          #error_messagesにnilが複数個入っている、なぜ？
          error_messages.delete(nil)
          @error_messages = error_messages
          # @error_messages = error_messages.delete(nil)だと@error_messages => nilで返ってくる、なんで？
          # @error_messages => ["4番目のカード指定文字が不正です。（H14)", "5番目のカード指定文字が不正です。（H14)"]
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
        @result = get_result(cards)
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
  end
end
