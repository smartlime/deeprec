class SearchService
  ALLOWED_TYPES = %w(question answer comment user)

  class << self
    def search(params)
      query = ThinkingSphinx::Query.escape(params[:query] || '')
      type = params[:type] || ''
      klass(type)&.search(query)
    end

    def klass(type)
      return ThinkingSphinx if type == ''
      return nil unless ALLOWED_TYPES.include?(type)
      type.classify.constantize
    end
  end
end
