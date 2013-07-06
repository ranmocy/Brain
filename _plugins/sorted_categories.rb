module Jekyll
  class SortedCategoriesBuilder < Generator

    safe true
    priority :high

    def generate(site)
      site.config['sorted_categories'] = site.categories.map { |category_name, posts|
        [ category_name, posts, posts.size, site.config['motto'][category_name].to_s ]
      }.sort { |a,b| a[0] <=> b[0] }

      site.config['grouped_categories'] = site.config['categories_group'].collect { |group|
        [
          group.first,
          group.last.collect { |category_name|
            posts = site.categories[category_name]
            [ category_name, posts, posts.size, site.config['motto'][category_name].to_s ]
          }
        ]
      }
    end

  end
end
