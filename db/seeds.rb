questions = []

4.times do
  questions.push Question.create(
    topic: "How to #{Faker::Hacker.verb} #{Faker::Hacker.adjective} " \
      "#{Faker::Hacker.noun} #{Faker::Hacker.noun} #{Faker::Hacker.ingverb} " \
      "#{Faker::Hacker.abbreviation}?",
    body: Faker::Lorem.paragraph(8, true, 8).gsub(/\.$/, '?'))
end

questions.each do |question|
  rand(8).times do
    Answer.create(
      question: question,
      body: Faker::Hacker.say_something_smart.capitalize)
  end
end
