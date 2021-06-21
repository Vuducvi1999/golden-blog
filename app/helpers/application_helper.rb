module ApplicationHelper
  def toastr_flash
    if flash.present?
      full_message = ''
      flash.each do |type, message|
        type = 'success' if type == 'notice'
        type = 'info' if type == 'info'
        type = 'error' if type == 'alert'
        text = "<script>toastr.#{type}('#{message}', '', \
        {timeOut: 0, extendedTimeOut: 0, closeButton: true, newestOnTop: true })</script>"
        full_message << text.html_safe
      end
      full_message.html_safe
    end
  end

  def toastr_custom_message message
    text = "<script>toastr.error('#{message}', '', \
    {timeOut: 0, extendedTimeOut: 0, closeButton: true, newestOnTop: true })</script>"
    return text.html_safe
  end

  def icon_sign_in_with provider 
    if provider == "Facebook"
      'fab fa-facebook-square'
    elsif provider == 'GoogleOauth2'
      'fab fa-google'
    end
  end

end
