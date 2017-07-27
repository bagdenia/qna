class ThinkingSphinxController < ApplicationController
  authorize_resource
  respond_to :html

  def search
    respond_with(@search_results = get_result)
  end

  def get_result
    search_area = params[:condition]
    case search_area
    when 'Everywhere', ''
      ThinkingSphinx.search params[:search_string]
    else
       search_area.singularize.classify.constantize.search params[:search_string]
    end
  end
end
