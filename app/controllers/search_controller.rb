class SearchController < ApplicationController
  before_filter :get_search_params

  def search
    @found = SearchService.search(type: @search_type, query: @search_query)
    render :no_results if @found.empty?
  end

  private

  def get_search_params
    @search_query = params[:q]
    @search_type = params[:t].to_s
    unless @search_type.blank? || SearchService::ALLOWED_TYPES.include?(@search_type)
      @search_type = nil
      render nothing: true, status: :not_implemented
    end
  end
end
