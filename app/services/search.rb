class Services::Search
  SEARCH_TYPES = { 'All': nil, 'Answers': Answer, 'Questions': Question, 'Comments': Comment, 'Users': User }

  def search(search_params)
    ThinkingSphinx.search Riddle::Query.escape(search_params[:search_string]), classes: get_classes(search_params[:search_type])
  end

  private
  def get_classes(search_type)
   return nil if search_type.empty?

   [search_type.capitalize.constantize]
  end


end
