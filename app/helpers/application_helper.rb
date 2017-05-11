module ApplicationHelper
  def lnil(date)
    date.nil? ? 'не указано' : l(date)
  end

  def nilTime(time)
    time.nil? ? 'не указано' : DateTime.parse(time.to_s).strftime("%H:%M")
  end

  def breadcrumb_tag(&block)
    render 'application/breadcrumb', block: capture(&block)
  end
  
  def is_powerful?
    @current_role_user.try(:is_admin?) || @current_role_user.try(:is_operator?)
  end
end
