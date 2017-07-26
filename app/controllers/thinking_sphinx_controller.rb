class ThinkingSphinxController < ApplicationController
  authorize_resource
  def search
    @search_results = ThinkingSphinx.search params[:search_string]
  end
end
