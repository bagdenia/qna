class Search
  SEARCH_LIST = %w(Questions Answers Comments Users)

  def self.search_result(search_string, search_area)
    string_with_escape = ThinkingSphinx::Query.escape(search_string)
    if SEARCH_LIST.include?(search_area)
       search_area.singularize.classify.constantize.search string_with_escape
    else
      ThinkingSphinx.search string_with_escape
    end
  end
end
