class SearchController < ApplicationController
  before_filter :get_search_params

  def search
  end

  private

  def get_search_params
    @search_query = params[:q]
    @search_type = params[:t].to_s
    puts "st: |#{@search_type.blank?}|"
    unless @search_type.blank? || %w(q a c u).include?(@search_type)
      @search_type = nil
      render :no_results, status: :unprocessable_entity
    end
  end
end
