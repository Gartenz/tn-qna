class SearchesController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  expose(:results) { [] }

  def search
    @exposed_results = Services::Search.new.search(search_params.to_h)
  end

  private

  def search_params
    params.require(:search).permit(:search_type, :search_string)
  end
end
