class MercuryParser

  BASE_URL = "https://mercury.postlight.com/parser"

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def self.parse(url)
    new(url)
  end

  def title
    result['title']
  end

  def content
    result['content']
  end

  def author
    result['author']
  end

  def published
    if result['date_published']
      Time.parse(result['date_published'])
    end
  end

  def date_published
    result['date_published'] if result['date_published']
  end

  def domain
    result['domain']
  end

  private

  def result
    @result ||= begin
      query = { url: url }
      uri = URI.parse(BASE_URL)
      uri.query = query.to_query
      response = HTTP.timeout(:global, write: 3, connect: 3, read: 3).headers("x-api-key" => ENV['MERCURY_API_KEY']).get(uri)
      response.parse
    end
  end

  def marshal_dump
    {
      result: result,
      url: url
    }
  end

  def marshal_load(data)
    @result = data[:result]
    @url = data[:url]
  end

end
