module TodoResponder
  def self.code_messages(code, message)
    responses = {
      404 => { error:   message || "resource not found." },
      204 => { success: message ||"success" },
      200 => { success: message || "success" },
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
