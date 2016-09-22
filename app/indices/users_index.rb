ThinkingSphinx::Index.define :user, with: :active_record do
  indexes user.email
end
