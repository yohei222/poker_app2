class PokerController < ApplicationController
  include ErrorMethods
  include PokerMethods

  def index

  end

  def judge
    #ここでの@cardsは入力された値（例："S1 H3 D9 C13 S11"）
    @cards = poker_params
    unless correct_blank?(@cards)
      flash.now[:alert] = '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
      render "index" and return
      renderを複数回呼び出すとエラーになるため、条件分岐した後「and return」で明示的に終了させる必要がある
    end
    error_messages = {}
    unless correct_cards?(@cards, error_messages)
      # error_messages => {5=>"5番目のカード指定文字が不正です。（H15)"}
      insert_flash(error_messages)
      #flashに{"0"=>"5番目のカード指定文字が不正です。（H15)"}が入る
      flash.now[:alert] = "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      # @flashes= {"0"=>"5番目のカード指定文字が不正です。（H15)", "alert"=>"半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"}
      render "index" and return
    end
    unless unique_card?(@cards)
      flash.now[:alert] = "カードが重複しています。"
      render "index" and return
    end
    @result = get_result(@cards)
    render "index" and return
  end

  private
  def poker_params
    params[:cards]
  end

end
