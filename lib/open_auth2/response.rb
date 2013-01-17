module OpenAuth2
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def parse
      result = OpenStruct.new(
        :status => response.status,
        :body => response.body,
        :headers => response.headers,
        :request => nil)

      result.request = OpenStruct.new(
          :url => response.env[:url].to_s,
          :headers => response.env[:request_headers]
      )

      result
    end
  end
end
