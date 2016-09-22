ThinkingSphinx::Index.define :user, with: :active_record, delta: true do
  indexes email
end
