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
        :request => {
          :url => response.env[:url],
          :headers => response.env[:request_headers]
      })

      result
    end
  end
end
