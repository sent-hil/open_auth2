module OpenAuth2
  class Connection
    attr_accessor :verb, :headers, :url, :body, :params

    def initialize(verb, params)
      @verb = verb
      @headers = params.delete(:headers) || {}
      @url = params.delete(:url) || ''
      @body = params.delete(:body) || ''
      @params = params
    end

    def fetch
      connection.send(verb) do |conn|
        conn.url url
        conn.headers = headers
        conn.body = body

        params.each do |key, value|
          conn.params[key] = value
        end
      end
    end

    def connection
      @connection ||= Faraday.new do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
      end

      @connection
    end
  end
end
