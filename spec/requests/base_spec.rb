require 'rails_helper'

describe Base, :type => :request do

  before do
    post '/api/v1/cards/check', :params => params.to_json, :headers => {'Content-Type': 'application/json'}
  end
  let(:params) { {"cards": cards} }

  context 'with correct cards' do

    let(:cards) { [
        "H1 H13 H12 H11 H10",
        "H9 C9 S9 H2 C2",
        "C13 D12 C11 H8 H7"
    ] }

    it 'returns correct values' do
      res = JSON.parse(response.body)
      expect(response.status).to eq 201
      expect(response).to be_success
      expect(res["result"][0]["card"]).to eq("H1 H13 H12 H11 H10")
      expect(res["result"][0]["hand"]).to eq("ストレートフラッシュ")
      expect(res["result"][0]["best"]).to be true
      expect(res["result"][1]["card"]).to eq("H9 C9 S9 H2 C2")
      expect(res["result"][1]["hand"]).to eq("フルハウス")
      expect(res["result"][1]["best"]).to be false
      expect(res["result"][2]["card"]).to eq("C13 D12 C11 H8 H7")
      expect(res["result"][2]["hand"]).to eq("ハイカード")
      expect(res["result"][2]["best"]).to be false
    end
  end

  context 'with incorrect cards' do

    let(:cards) { [
        "H1H13 H12 H11 H10",
        "H9 C22 S9 H2 C2",
        "C13 D12 C11 C11 H7"
    ] }

    it 'returns errors' do
      res = JSON.parse(response.body)
      expect(response.status).to eq 201
      expect(response).to be_success
      expect(res["error"][0]["card"]).to eq("H1H13 H12 H11 H10")
      expect(res["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")

      expect(res["error"][1]["card"]).to eq("H9 C22 S9 H2 C2")
      expect(res["error"][1]["msg"]).to eq("2番目のカード指定文字が不正です。（C22)")

      expect(res["error"][2]["card"]).to eq("C13 D12 C11 C11 H7")
      expect(res["error"][2]["msg"]).to eq("カードが重複しています。")

    end
  end

  #JSON.parse() メソッドは文字列を JSON として解析し、文字列によって記述されている JavaScript の値やオブジェクトを構築します
  context 'when there is a specific error' do
    context 'when there is an space' do
      let(:cards) { [" "]}
      it 'returns errors' do
        res = JSON.parse(response.body)
        expect(response.status).to eq 201
        expect(response).to be_success
        expect(res["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")
      end
    end

    context 'when there is no data in params' do
      let(:cards) { {} }
      it 'returns errors' do
        res = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(response).not_to be_success
        expect(res["error"][0]["msg"]).to eq("不正なリクエストです。")
      end
    end

    context 'when there is no data in params' do
      let(:cards) { [{ }] }
      it 'returns errors' do
        res = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(response).not_to be_success
        expect(res["error"][0]["msg"]).to eq("不正なリクエストです。")
      end
    end
  end
end
