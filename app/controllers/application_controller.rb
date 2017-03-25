class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def add_breadcrumb name, url = ''
      @breadcrumbs ||= []
      url = eval(url) if url =~ /_path|_url|@/
      @breadcrumbs << [name, url]
    end
   
    def self.add_breadcrumb name, url, options = {}
      before_filter options do |controller|
        controller.send(:add_breadcrumb, name, url)
      end
    end
end
