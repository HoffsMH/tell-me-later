module TodoResponder
  def self.resource_created(resource)
    groom_response(code: 204,
                   resource: {resource.type  => resource.as_json},
                   message: "Resource Created")
  end

  def self.unprocessable_entity(resource)
    groom_response(code: 422,
                   resource: {resource.type  => nil },
                   message: resource.errors.full_messages.join(" "))
  end

  def self.resource_deleted(resource)
    groom_response(code: 204,
                   resource: {resource.type  => resource.as_json},
                   message: "Resource Deleted")
  end

  def self.resource_not_found(resource_type)
    groom_response(code: 404,
                   resource: {resource_type => nil})
  end

  def self.code_messages(code, message)
    responses = {
      404 => { error:   message || "Resource not Found." },
      204 => { success: message || "Success" },
      200 => { success: message || "Success" },
      422 => { error:   message || "Unprocessable Entity"}
    }
    responses[code]
  end

  def self.groom_response(args)
    resource = args[:resource]
    code     = args[:code]
    message  = args[:message]
    {
      status:  code,
      message: code_messages(code, message),
      data: resource
    }
  end
end
