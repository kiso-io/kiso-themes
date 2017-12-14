module MailPreviewHelper
  def render_mail_preview(mailer, mail)
    mailer_preview_class = "#{mailer}_preview".camelize.constantize
    @email = mailer_preview_class.new.send(mail)
    ActionMailer::InlinePreviewInterceptor.previewing_email(@email)
    part = @email.find_first_mime_type('text/html') || @email
    raw(part.decoded)
  end
end
