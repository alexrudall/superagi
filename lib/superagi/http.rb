module SuperAGI
  module HTTP
    def get(path:)
      to_json(conn.get(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    def json_post(path:, parameters:)
      to_json(conn.post(uri(path: path)) do |req|
        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def json_put(path:, parameters:)
      to_json(conn.put(uri(path: path)) do |req|
        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def delete(path:)
      to_json(conn.delete(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    private

    def to_json(string)
      return unless string

      JSON.parse(string)
    rescue JSON::ParserError
      # Convert a multiline string of JSON objects to a JSON array.
      JSON.parse(string.gsub("}\n{", "},{").prepend("[").concat("]"))
    end

    def conn(multipart: false)
      Faraday.new do |f|
        f.options[:timeout] = @request_timeout
        f.request(:multipart) if multipart
      end
    end

    def uri(path:)
      File.join(@uri_base, @api_version, path)
    end

    def headers
      superagi_headers.merge(@extra_headers || {})
    end

    def superagi_headers
      {
        "Content-Type" => "application/json",
        "X-api-key" => @secret_key
      }
    end
  end
end
