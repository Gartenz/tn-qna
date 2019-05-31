class SearchesController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  expose(:results) { [] }
  def search
    @exposed_results = ThinkingSphinx.search params['search'], classes: get_classes
  end

  private

  def get_classes
   return nil if params['search_type'].empty?

   [params['search_type'].capitalize.constantize]
  end
end
