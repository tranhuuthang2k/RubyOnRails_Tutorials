module ApplicationHelper
  def full_title page_title = ""
    base_title = "Welcome To Ruby"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
  def displayName 
    nam="Tran Huu Thang"
  end  
end