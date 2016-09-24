require 'features_helper'

feature 'Search Questions', %q(
  To get information I need
  As a Guest
  I want to search information in Questions
), :sphinx do
  given!(:object) { create(:question) }

  include_examples :sphinx_search_feature, :topic
end

feature 'Search Answers', %q(
  To get information I need
  As a Guest
  I want to search information in Answers
), :sphinx do
  given!(:object) { create(:answer) }

  include_examples :sphinx_search_feature
end

feature 'Search Answers Comments', %q(
  To get information I need
  As a Guest
  I want to search information in Answers Comments
), :sphinx do
  given!(:object) { create(:comment, commentable: create(:answer)) }

  include_examples :sphinx_search_feature
end

feature 'Search Questions Comments', %q(
  To get information I need
  As a Guest
  I want to search information in Questions Comments
), :sphinx do
  given!(:object) { create(:comment, commentable: create(:question)) }

  include_examples :sphinx_search_feature
end

feature 'Search Users', %q(
  To get information I need
  As a Guest
  I want to search information in Answers
), :sphinx do
  given!(:object) { create(:user) }

  include_examples :sphinx_search_feature, :email
end
