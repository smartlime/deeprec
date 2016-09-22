class SearchController < ApplicationController
  before_filter :get_search_params

  def search
    @found = search_class.search(@search_query)
    render :no_results if @found.empty?
  end

  private

  def search_class
    puts "ST: #{@search_type}"
    case @search_type
      when '' then ThinkingSphinx
      when 'q' then Question
      when 'a' then Answer
      when 'c' then Commient
      when 'u' then User
    end
  end

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
