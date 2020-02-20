require 'rails_helper'

RSpec.describe PokerController, type: :controller do
  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#judge" do
    before do
      post :judge, params: { cards: cards }
    end
    context "with correct params" do
      context "Four Card" do
        let(:cards) { "H1 S1 C1 D1 H2" }
        it "should be Four Card" do
          expect(assigns(:result)).to eq "Four Card"
        end
      end
      context "Full House" do
        let(:cards) { "H1 S1 C1 D2 H2" }
        it "should be Full House" do
          expect(assigns(:result)).to eq "Full House"
        end
      end
      context "Three Card" do
        let(:cards) { "H1 S1 C1 D3 H2" }
        it "should be Three Card" do
          expect(assigns(:result)).to eq "Three Card"
        end
      end
      context "Two Pair" do
        let(:cards) { "H1 S1 C13 D13 H2" }
        it "should be Two Pair" do
          expect(assigns(:result)).to eq "Two Pair"
        end
      end
      context "One Pair" do
        let(:cards) { "H1 S1 C13 D12 H2" }
        it "should be One Pair" do
          expect(assigns(:result)).to eq "One Pair"
        end
      end
      context "Straight Flush" do
        let(:cards) { "H2 H3 H4 H5 H6" }
        it "should be Straight Flush" do
          expect(assigns(:result)).to eq "Straight Flush"
        end
      end
      context "Straight" do
        let(:cards) { "H2 D3 C4 S5 H6" }
        it "should be Straight" do
          expect(assigns(:result)).to eq "Straight"
        end
      end
      context "Flush" do
        let(:cards) { "H2 H13 H4 H5 H7" }
        it "should be Flush" do
          expect(assigns(:result)).to eq "Flush"
        end
      end
      context "High Card" do
        let(:cards) { "H2 D3 C12 S5 H10" }
        it "should be High Card" do
          expect(assigns(:result)).to eq "High Card"
        end
      end
    end
    context "with incorrect params" do
      context "correct_blank?" do
        let(:cards){ "H1H2H3H4H5" }
        it "should be an error" do
          expect(flash.now[:alert]).to eq '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
        end
      end
      context "correct_cards?" do
        let(:cards){ "D1 D2 S15 S2 S3" }
        it "should be an error" do
          expect(flash.now[:alert]).to eq "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
          expect(flash.now[0]).to eq "3番目のカード指定文字が不正です。（S15） "
        end
      end
      context "unique_card?" do
        let(:cards){ "H1 H1 H2 H3 S5" }
        it "should be an error" do
          expect(flash.now[:alert]).to eq "カードが重複しています。"
        end
      end
    end
  end
end
