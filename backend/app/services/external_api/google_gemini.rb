module ExternalApi
  module GoogleGemini
    def self.client
      @client ||= Client.new
    end

    def self.generate_content(conversation_contents)
      client.generate_content(conversation_contents)
    end
  end
end
