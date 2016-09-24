ThinkingSphinx::Index.define :question, with: :active_record, delta: true do
  indexes topic, sortable: true
  indexes body
end
