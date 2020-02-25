require 'rails_helper'

describe Base, :type => :request do

  before do
    post '/api/v1/cards/check', :params => params.to_json, headers: headers
  end

  let(:headers) { {'Content-Type': content_type} }
  let(:params) { {"cards": cards} }
  subject { response.status }

  context '正常系' do

    let(:content_type) {'application/json'}
    let(:cards) { [
        "H1 H13 H12 H11 H10"
    # "S1 S2 S3 S4 S5",
    # "S1 S2 S3 H1 H2"
    ] }

    it { is_expected.to eq 201 }

    it 'ポーカーの結果を返す' do
      parsed_json = JSON.parse(response.body)

      expect(parsed_json["result"][0]["card"]).to eq("H1 H13 H12 H11 H10")
      expect(parsed_json["result"][0]["hand"]).to eq("ストレートフラッシュ")
      expect(parsed_json["result"][0]["best"]).to be true
      # expect(parsed_json["result"][1]["card"]).to eq("S1 S2 S3 S4 S5")
      # expect(parsed_json["result"][1]["hand"]).to eq("ストレートフラッシュ")
      # expect(parsed_json["result"][1]["best"]).to be true
      # expect(parsed_json["result"][2]["card"]).to eq("S1 S2 S3 H1 H2")
      # expect(parsed_json["result"][2]["hand"]).to eq("2ペア")
      # expect(parsed_json["result"][2]["best"]).to be false
    end
  end
  
end
