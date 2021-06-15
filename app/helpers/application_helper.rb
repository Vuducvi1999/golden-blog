module ApplicationHelper
  def toastr_flash
    if flash.present?
      full_message = ''
      flash.each do |type, message|
        type = 'success' if type == 'notice'
        type = 'error' if type == 'alert'
        text = "<script>toastr.#{type}('#{message}', '', { closeButton: true, newestOnTop: true })</script>"
        full_message << text.html_safe
      end
      full_message.html_safe
    end
  end

  def icon_sign_in_with provider 
    if provider == "Facebook"
      'fab fa-facebook-square'
    elsif provider == 'GoogleOauth2'
      'fab fa-google'
    end
  end
end
