module LinksHelper
  def is_gist(link)
    res = link.url.match(/https\:\/\/(gist.github.com)/)
    !res.nil?
  end

  def get_gist_files(link)
    res = link.url.match(/https\:\/\/gist.github.com\/[^\/]+\/(?<id>[^\/]+)/)
    return unless res

    result = GistService.new.gist(res[:id])
    result.files
  end
end
