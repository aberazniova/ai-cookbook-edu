module ExternalApi
  module GoogleGemini
    class Client < Base
      def generate_content(prompt)
        post("", build_payload(prompt))
      end

      private

      def build_payload(prompt)
        {
          **gemini_config,
          contents: [
            {
              parts: [
                { text: prompt }
              ]
            }
          ]
        }
      end

      def gemini_config
        @_gemini_config ||= YAML.load_file(Rails.root.join("config", "gemini.yml"))
      end
    end
  end
end
