ThinkingSphinx::Index.define :question, with: :active_record do
  indexes topic, sortable: true
  indexes body
  indexes user.email
end
