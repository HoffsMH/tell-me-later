module TodoResponses
  def self.resource_created(resource)
    TodoResponder.
    groom_response(
    code: 204,
    resource: {resource.type  => resource.as_json},
    message: "Resource Created")
  end

  def self.unprocessable_entity(resource)
    TodoResponder.
    groom_response(
    code: 422,
    resource: {resource.type  => resource.as_json },
    message: resource.errors.full_messages.join(" "))
  end

  def self.resource_deleted(resource)
    TodoResponder.
    groom_response(
    code: 204,
    resource: {resource.type  => resource.as_json},
    message: "Resource Deleted")
  end

  def self.resource_not_found(resource_type)
    TodoResponder.
    groom_response(
    code: 404,
    resource: {resource_type => nil})
  end

  def self.resource_updated(resource)
    TodoResponder.
    groom_response(
    code: 204,
    resource: {resource.type  => resource.as_json},
    message: "Resource Updated")
  end
end
