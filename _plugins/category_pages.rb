module Jekyll

  class Page

    def clone
      Page.new(@site, @base, @dir, @name)
    end

  end

  class CategoryPageGenerator < Generator
    safe true
    priority :high

    def generate(site)
      main_category_page = site.pages.select { |p| p.name == "category.html" }.first

      site.categories.each do |category|
        category_page = main_category_page.clone
        category_name = category.first.gsub(/\s+/, '-')

        category_page.data.merge!(
          "permalink" => "/#{category_name}/",
          "categories" => [category_name])
        category_page.render(site.layouts, site.site_payload)

        site.pages << category_page
      end

    end

  end
end
