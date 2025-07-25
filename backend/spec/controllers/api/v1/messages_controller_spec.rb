require "rails_helper"

RSpec.describe Api::V1::MessagesController, type: :controller do
  describe "#index" do
    subject(:do_request) { get :index }

    let!(:conversation) { create(:conversation) }

    context "when conversation has no messages" do
      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty messages array" do
        do_request
        json_response = JSON.parse(response.body)
        expect(json_response["messages"]).to eq([])
      end
    end

    context "when conversation has messages" do
      before do
        create_list(:conversation_turn, 2, :user_message, conversation: conversation)
      end

      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns the messages with the text content and roles" do
        do_request
        json_response = JSON.parse(response.body)
        expect(json_response["messages"]).to eq(conversation.conversation_turns.map { |turn| { "textContent" => turn.text_content, "role" => turn.role.to_s } })
      end
    end

    context "when testing limiting functionality" do
      let(:max_display_limit) { ConversationTurn::MAX_MESSAGES_DISPLAY_LIMIT }

      before do
        create_list(:conversation_turn, max_display_limit + 5, :user_message, conversation: conversation)
      end

      it "returns only the last MAX_MESSAGES_DISPLAY_LIMIT messages" do
        do_request
        json_response = JSON.parse(response.body)
        expect(json_response["messages"].length).to eq(max_display_limit)
      end

      it "returns the most recent messages when limit is exceeded" do
        do_request
        json_response = JSON.parse(response.body)

        expected_turns = conversation.conversation_turns.text_messages.limited_for_display

        expect(json_response["messages"].map { |msg| msg["textContent"] }).to eq(
          expected_turns.map(&:text_content)
        )
      end
    end

    context "when testing ordering functionality" do
      let!(:first_message) { create(:conversation_turn, :user_message, conversation: conversation, created_at: 1.hour.ago) }
      let!(:second_message) { create(:conversation_turn, :model, conversation: conversation, created_at: 30.minutes.ago) }
      let!(:third_message) { create(:conversation_turn, :user_message, conversation: conversation, created_at: 15.minutes.ago) }

      it "returns messages ordered by creation time ascending" do
        do_request
        json_response = JSON.parse(response.body)

        expected_order = [first_message, second_message, third_message]
        actual_order = json_response["messages"].map { |msg| msg["textContent"] }

        expect(actual_order).to eq(expected_order.map(&:text_content))
      end
    end

    context "when conversation has messages without text content" do
      let!(:text_message) { create(:conversation_turn, :user_message, conversation: conversation, text_content: "Hello") }
      let!(:empty_text_message) { create(:conversation_turn, :model, conversation: conversation, text_content: nil) }

      it "only returns messages with text content" do
        do_request
        json_response = JSON.parse(response.body)

        expect(json_response["messages"].length).to eq(1)
        expect(json_response["messages"].first["textContent"]).to eq("Hello")
      end
    end

    context "when testing with different message types" do
      let!(:user_message) { create(:conversation_turn, :user_message, conversation: conversation, text_content: "User message") }
      let!(:model_message) { create(:conversation_turn, :model, conversation: conversation, text_content: "Model response") }

      it "returns both user and model messages with correct roles" do
        do_request
        json_response = JSON.parse(response.body)

        expect(json_response["messages"].length).to eq(2)
        expect(json_response["messages"].map { |msg| msg["role"] }).to contain_exactly("user", "model")
      end
    end
  end

  describe "#create" do
    subject(:do_request) { post :create, params: { message: message } }

    let(:message) { "Hello, how are you?" }

    before do
      allow(Chatbot::ProcessUserMessage).to receive(:call).and_return(
        Struct.new(:success?, :response_message, :error).new(true, "Stubbed response message", nil)
      )
    end

    context "when user message is present" do
      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns a response message" do
        do_request
        expect(response.body).to include("Stubbed response message")
      end
    end

    context "when user message is not present" do
      let(:message) { "" }

      it "returns bad request status" do
        do_request
        expect(response).to have_http_status(:bad_request)
      end

      it "returns error message" do
        do_request
        expect(response.body).to include("Message must be present.")
      end
    end
  end
end
