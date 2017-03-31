class WanikaniApi

  attr_reader :api_key

  def initialize()
    @api_key = ENV['WANIKANI_API_KEY']
  end
  
  def get(url)
    response = RestClient.get("https://www.wanikani.com/api/user/#{@api_key}/#{url}/")
    JSON.parse response.body
  end

end
