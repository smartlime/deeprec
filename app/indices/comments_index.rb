ThinkingSphinx::Index.define :comment, with: :active_record, delta: true do
  indexes body
end
