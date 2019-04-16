class GistService
  def initialize(client: nil)
    @client = client || Octokit::Client.new
  end

  def gist(id)
    @client.gist(id)
  end
end
