# Other authorizers should subclass this one
class ClothSetAuthorizer < Authority::Authorizer

  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    user.has_role?(:admin)
  end

  def updatable_by?(user)
    resource.profile == user.profile  || user.has_role?(:admin)
  end

  def deletable_by?(user)
    resource.profile == user.profile || user.has_role?(:admin)
  end

  def creatable_by?(user)
    resource.profile == user.profile || user.has_role?(:admin)
  end

  def readable_by?(user)
    #resource.profile == user.profile || resource.profile.followers.exists?(user.profile.id) || user.has_role?(:admin)
    true
  end
end
