ThinkingSphinx::Index.define :answer, with: :active_record, delta: true do
  indexes body
end
