# -*- coding: utf-8 -*-

set :title, "Ranmocy's Fragments"
set :description, "My Brain, My Treasure."
set :author, "Ranmocy"
set :email, "Ranmocy@gmail.com"

set :categories_group, {
  life: [
    "blog",
    "diary",
    "dream",
    "poem",
  ],
  idea: [
    "motto",
    "idea",
    "remark",
    "philosophy",
  ],
  work: [
    "tech",
    "piece",
  ],
}

set :motto, {
  blog: "旅行日志",
  diary: "一个欲望灼烧者艰难写下的自白。",
  dream: "最真实总是梦境",
  poem: "用诗歌来拯救自我",
  motto: "一句话评点世界",
  idea: "思维碎片，漂浮在名叫头脑的海洋。",
  remark: "从这个世界剥离出的抽象",
  philosophy: "我在教导你们世界运行的原动力。你们听之，想之，就忘之吧。",
  tech: "技术宅拯救世界。",
  piece: "What I did define what I am.",
}

#   # blog.summary_separator = /(READMORE)/
#   # blog.summary_length = 250


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


# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

set :ignored_sitemap_matchers, {
  # :root_dotfiles => proc { |file| file.start_with?('.') },
  :source_dotfiles => proc { |file|
    file =~ %r{/\.} && file !~ %r{/\.(htaccess|htpasswd|nojekyll)}
  },
  :partials => proc { |file| file =~ %r{/_[^_]} },
  :layout => proc { |file, app|
    file.start_with?(File.join(app.config[:source], 'layout.')) ||
    file.start_with?(File.join(app.config[:source], 'layouts/'))
  },
}

set :layout, 'default'

set :source, ".site"
set :build_dir, '.built'
set :layouts_dir, 'layouts'
set :partials_dir, 'layouts'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

activate :livereload
activate :directory_indexes


#page "/atom.xml", :layout => false

# Blog layouts
categories = ["Blog", "Diary", "Dream", "Idea", "Org", "Philosophy",
              "Piece", "Poem", "Remark", "Tech", "Young"]
categories.each do |category|
  page "/#{category}/*", layout: "article"
end
with_layout :piece do
  page "/Piece/*"
  page "/Poem/*"
  page "/Tech/*"
end

# Methods defined in the helpers block are available in templates
helpers do
  def active?(category)
    page_classes.split.map(&:downcase).include?(category.downcase) ? 'active' : ''
  end
end

# Categories index
ready do
  sitemap.resources.group_by {|p| p.data["category"] }.each do |category, pages|
    category = category || 'Unknown'
    proxy "/#{category}/index.html", "/templates/category.html", ignore: true,
    layout: "default", category: category.to_s, locals: {category: category, pages: pages} do
      @category = category
    end
  end
end

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
