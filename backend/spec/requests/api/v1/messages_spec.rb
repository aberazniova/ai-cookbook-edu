require "rails_helper"

shared_examples "creates conversation and sets cookie when missing" do
  it "creates a conversation for the user" do
    expect { do_request }.to change { user.conversations.count }.by(1)
  end

  it "sets an encrypted HttpOnly conversation_id cookie" do
    do_request

    set_cookie = response.headers["Set-Cookie"]
    conversation_cookie = set_cookie.to_s.split("\n").find { |c| c.start_with?("conversation_id=") }
    expect(conversation_cookie).to be_present
    expect(conversation_cookie.downcase).to include("httponly")
  end
end

RSpec.describe "Messages API", type: :request do
  describe "GET /api/v1/messages" do
    subject(:do_request) { get "/api/v1/messages", headers: headers }

    it_behaves_like "when unauthorized"

    context "with valid access token" do
      let(:user) { create(:user) }
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user) }

      context "when no conversation cookie is present" do
        include_examples "creates conversation and sets cookie when missing"

        it "returns a successful response" do
          do_request
          expect(response).to have_http_status(:ok)
        end

        it "returns an initial model message" do
          do_request

          expect(json_response[0]["text_content"]).to eq(Conversations::Create::INITIAL_MESSAGE_FROM_MODEL)
          expect(json_response[0]["role"]).to eq("model")
        end
      end

      context "when conversation id cookie is present" do
        let!(:conversation) { create(:conversation, user: user) }

        before do
          # Stubbing the controller's conversation_id in the spec because crafting a real
          # cookies.encrypted value ties tests to encryption internals.
          allow_any_instance_of(Api::V1::MessagesController).to receive(:conversation_id).and_return(conversation.id)
        end

        context "when conversation has no messages" do
          it "returns a successful response" do
            do_request
            expect(response).to have_http_status(:ok)
          end

          it "returns an empty array" do
            do_request
            expect(json_response).to eq([])
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

          it "returns the messages with the correct attributes" do
            do_request
            expect(json_response[0].keys).to include("text_content", "role", "id", "recipe")
          end
        end

        context "for limiting functionality" do
          let(:max_display_limit) { ConversationTurn::MAX_MESSAGES_DISPLAY_LIMIT }

          before do
            create_list(:conversation_turn, max_display_limit + 5, :user_message, conversation: conversation)
          end

          it "returns only the last MAX_MESSAGES_DISPLAY_LIMIT messages" do
            do_request
            expect(json_response.length).to eq(max_display_limit)
          end

          it "returns the most recent messages when limit is exceeded" do
            do_request

            expected_turns = conversation.conversation_turns.text_messages.limited_for_display

            expect(json_response.map { |msg| msg["text_content"] }).to eq(
              expected_turns.map(&:text_content)
            )
          end
        end

        context "for ordering functionality" do
          let!(:first_message) { create(:conversation_turn, :user_message, conversation: conversation, created_at: 1.hour.ago) }
          let!(:second_message) { create(:conversation_turn, :model, conversation: conversation, created_at: 30.minutes.ago) }
          let!(:third_message) { create(:conversation_turn, :user_message, conversation: conversation, created_at: 15.minutes.ago) }

          it "returns messages ordered by creation time ascending" do
            do_request

            expected_order = [first_message, second_message, third_message]
            actual_order = json_response.map { |msg| msg["text_content"] }

            expect(actual_order).to eq(expected_order.map(&:text_content))
          end
        end

        context "when conversation has messages without text content" do
          let!(:text_message) { create(:conversation_turn, :user_message, conversation: conversation, text_content: "Hello") }
          let!(:empty_text_message) { create(:conversation_turn, :model, conversation: conversation, text_content: nil) }

          it "only returns messages with text content" do
            do_request

            expect(json_response.length).to eq(1)
            expect(json_response.first["text_content"]).to eq("Hello")
          end
        end

        context "for different message types" do
          let!(:user_message) { create(:conversation_turn, :user_message, conversation: conversation, text_content: "User message") }
          let!(:model_message) { create(:conversation_turn, :model, conversation: conversation, text_content: "Model response") }

          it "returns both user and model messages with correct roles" do
            do_request

            expect(json_response.length).to eq(2)
            expect(json_response.map { |msg| msg["role"] }).to contain_exactly("user", "model")
          end
        end
      end
    end
  end

  describe "POST /api/v1/messages" do
    subject(:do_request) { post "/api/v1/messages", params: params, headers: headers }

    let(:params) { { message: message } }
    let(:message) { "Hello, how are you?" }

    it_behaves_like "when unauthorized"

    context "with valid access token" do
      let(:user) { create(:user) }
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user) }

      before do
        allow(Chatbot::ProcessUserMessage).to receive(:call).and_return(
          Struct.new(:success?, :response_message, :error).new(true, "Stubbed response message", nil)
        )
      end

      context "when user message is present" do
        it "returns a successful response" do
          post "/api/v1/messages", params: params, headers: headers
          expect(response).to have_http_status(:ok)
        end

        it "returns a response message" do
          post "/api/v1/messages", params: params, headers: headers
          expect(response.body).to include("Stubbed response message")
        end

        context "when conversation id cookie is present" do
          include_examples "creates conversation and sets cookie when missing"

          it "calls Chatbot::ProcessUserMessage with the created conversation" do
            do_request
            conversation = Conversation.last

            expect(Chatbot::ProcessUserMessage).to have_received(:call).with(
              message_content: message,
              conversation: conversation
            )
          end
        end

        context "when conversation id cookie is present" do
          let(:conversation) { create(:conversation, user: user) }

          before do
            # Stubbing the controller's conversation_id in the spec because crafting a real
            # cookies.encrypted value ties tests to encryption internals.
            allow_any_instance_of(Api::V1::MessagesController).to receive(:conversation_id).and_return(conversation.id)
          end

          it "calls Chatbot::ProcessUserMessage with the existing conversation" do
            expect(Chatbot::ProcessUserMessage).to receive(:call).with(
              message_content: message,
              conversation: conversation
            )
            do_request
          end
        end
      end

      context "when user message is not present" do
        let(:message) { "" }

        it "returns bad request status" do
          post "/api/v1/messages", params: params, headers: headers
          expect(response).to have_http_status(:bad_request)
        end

        it "returns error message" do
          post "/api/v1/messages", params: params, headers: headers
          expect(response.body).to include("Message must be present.")
        end
      end
    end
  end
end
