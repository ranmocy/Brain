module Jekyll
  class SortedCategoriesBuilder < Generator

    safe true
    priority :high

    def generate(site)
      site.config['sorted_categories'] = site.categories.map { |cat, posts|
        [ cat, posts, posts.size, site.config['motto'][cat].to_s ]
        }.sort { |a,b| a[0] <=> b[0] }
    end

  end
end
