class SearchService
  class << self
    def search(params)
      query = ThinkingSphinx::Query.escape(params[:query] || '')
      type = params[:type] || ''
      klass(type)&.search(query)
    end

    private

    def klass(type)
      case type
        when '' then
          ThinkingSphinx
        when 'q' then
          Question
        when 'a' then
          Answer
        when 'c' then
          Comment
        when 'u' then
          User
        else
          nil
      end
    end
  end
end
