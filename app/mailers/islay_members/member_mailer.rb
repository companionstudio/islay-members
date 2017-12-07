class IslayMembers::MemberMailer <  Devise::Mailer
  helper '/islay/public/application'

  default :from => Settings.for(:shop, :email),
          :bcc => Settings.for(:shop, :email),
          :charset => 'UTF-8'

  layout 'mail'

  def new_registration(record, opts={})
    devise_mail(record, :new_registration, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def confirmation_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :confirmation_instructions, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :reset_password_instructions, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def unlock_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :unlock_instructions, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def email_changed(record, opts={})
    devise_mail(record, :email_changed, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def password_change(record, opts={})
    devise_mail(record, :password_change, opts) do |format|
      format.html {with_inline_styles render}
    end
  end

  def default_url_options
    {
      :host => host,
      :port => port
    }
  end

  private

  def host
    Figaro.env.ic_islay_email_host
  end

  def port
    Figaro.env.ic_islay_email_port
  end

  def with_inline_styles(html)
    Premailer.new(html, :with_html_string => true).to_inline_css
  end

end
