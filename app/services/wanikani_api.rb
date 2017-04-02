class WanikaniApi

  attr_reader :api_key

  def initialize()
    @api_key = ENV['WANIKANI_API_KEY']
  end
  
  def get(url)
    response = RestClient.get(get_url(url))
    JSON.parse response.body
  end
  
  def get_url(url)
    "https://www.wanikani.com/api/user/#{@api_key}/#{url}/"
  end

end
