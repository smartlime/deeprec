module RateablePolicy
  def rate?
    admin? || user? && !owner?
  end

  def rate_revoke?
    admin? || owner?
  end
end