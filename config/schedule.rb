every 1.day, at: '9:00' do
  runner 'MailDigestJob.perform_later'
end

every 1.hour, at: 42 do
  rake 'ts:rebuild'
end
