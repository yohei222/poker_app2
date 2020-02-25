require 'rails_helper'

describe Base, :type => :request do

  before do
    post '/api/v1/cards/check', :params => params.to_json, headers: headers
  end

  let(:headers) { {'Content-Type': content_type} }
  let(:params) { {"cards": cards} }
  subject { response.status }

  context 'with correct cards' do

    let(:content_type) {'application/json'}
    let(:cards) { [
        "H1 H13 H12 H11 H10",
        "H9 C9 S9 H2 C2",
        "C13 D12 C11 H8 H7"
    ] }

    it { is_expected.to eq 201 }

    it 'returns correct values' do
      parsed_json = JSON.parse(response.body)

      expect(parsed_json["result"][0]["card"]).to eq("H1 H13 H12 H11 H10")
      expect(parsed_json["result"][0]["hand"]).to eq("ストレートフラッシュ")
      expect(parsed_json["result"][0]["best"]).to be true
      expect(parsed_json["result"][1]["card"]).to eq("H9 C9 S9 H2 C2")
      expect(parsed_json["result"][1]["hand"]).to eq("フルハウス")
      expect(parsed_json["result"][1]["best"]).to be false
      expect(parsed_json["result"][2]["card"]).to eq("C13 D12 C11 H8 H7")
      expect(parsed_json["result"][2]["hand"]).to eq("ハイカード")
      expect(parsed_json["result"][2]["best"]).to be false
    end
  end

  context 'with incorrect cards' do

    let(:content_type) {'application/json'}
    let(:cards) { [
        "H1H13 H12 H11 H10",
        "H9 C22 S9 H2 C2",
        "C13 D12 C11 C11 H7"
    ] }

    it { is_expected.to eq 201 }

    it 'returns errors' do
      parsed_json = JSON.parse(response.body)

      expect(parsed_json["error"][0]["card"]).to eq("H1H13 H12 H11 H10")
      expect(parsed_json["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")

      expect(parsed_json["error"][1]["card"]).to eq("H9 C22 S9 H2 C2")
      expect(parsed_json["error"][1]["msg"]).to eq("2番目のカード指定文字が不正です。（C22)")

      expect(parsed_json["error"][2]["card"]).to eq("C13 D12 C11 C11 H7")
      expect(parsed_json["error"][2]["msg"]).to eq("カードが重複しています。")

    end
  end

  context 'when there is a specific error' do
    context 'when there is an space' do
      let(:content_type) {'application/json'}
      let(:cards) { [" "] }
      it { is_expected.to eq 201 }
      it 'returns errors' do
        parsed_json = JSON.parse(response.body)
        expect(parsed_json["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")
      end
    end

    context 'when there is no data in params' do
      let(:content_type) {'application/json'}
      let(:cards) { [" "] }
      it { is_expected.to eq 201 }
      it 'returns errors' do
        parsed_json = JSON.parse(response.body)
        expect(parsed_json["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。")
      end
    end

    context 'when there is no data in params' do
      let(:content_type) {'application/json'}
      let(:cards) { [{ }] }
      it { is_expected.to eq 400 }
      it 'returns errors' do
        parsed_json = JSON.parse(response.body)
        expect(parsed_json["error"][0]["msg"]).to eq("不正なリクエストです。")
      end
    end
  end
end