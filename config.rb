###
# Blog settings
###

# Time.zone = "Pacific Time (US & Canada)"

# activate :blog do |blog|
#   # blog.prefix = "blog"
#   # blog.permalink = ":year/:month/:day/:title.html"
#   # blog.sources = ":year-:month-:day-:title.html"
#   # blog.taglink = "tags/:tag.html"
#   # blog.layout = "layout"
#   # blog.summary_separator = /(READMORE)/
#   # blog.summary_length = 250
#   # blog.year_link = ":year.html"
#   # blog.month_link = ":year/:month.html"
#   # blog.day_link = ":year/:month/:day.html"
#   blog.default_extension = [".markdown", ".md"]

#   blog.tag_template = "tag.html"
#   blog.calendar_template = "calendar.html"

#   # blog.paginate = true
#   # blog.per_page = 10
#   # blog.page_link = "page/:num"
# end

# page "/feed.xml", :layout => false

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :ignored_sitemap_matchers, {
  # :root_dotfiles => proc { |file| file.start_with?('.') },
  # :source_dotfiles => proc { |file|
  #   file =~ %r{/\.} && file !~ %r{/\.(htaccess|htpasswd|nojekyll)}
  # },
  :partials => proc { |file| file =~ %r{/_[^_]} },
  :layout => proc { |file, app|
    file.start_with?(File.join(app.config[:source], 'layout.')) ||
    file.start_with?(File.join(app.config[:source], 'layouts/'))
  },
}

set :source, ".site"
set :build_dir, '.built'
set :partials_dir, '_partials'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

activate :livereload
activate :directory_indexes

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
