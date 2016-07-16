@updateRatingPanel = (data) ->
  $('#rating-' + data.id).text(data.rating)
  if data.revoked
    $('#rate-inc-' + data.id).show()
    $('#rate-dec-' + data.id).show()
    $('#rate-revoke-' + data.id).hide()
  else
    $('#rate-inc-' + data.id).hide()
    $('#rate-dec-' + data.id).hide()
    $('#rate-revoke-' + data.id).show()
