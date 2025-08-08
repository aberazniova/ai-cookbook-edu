module ExternalApi
  module GoogleGemini
    class Client < Base
      def generate_content(conversation_contents)
        post("", build_payload(conversation_contents))
      end

      private

      def build_payload(conversation_contents)
        {
          **gemini_config,
          contents: conversation_contents,
          generationConfig: {
            temperature: ENV.fetch("GOOGLE_GEMINI_TEMPERATURE", 1.2).to_f
          }
        }
      end

      def gemini_config
        @_gemini_config ||= YAML.load_file(Rails.root.join("config", "gemini.yml"))
      end
    end
  end
end
