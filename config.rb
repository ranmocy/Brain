require 'pathname'
require 'yaml'
require 'time' # support iso8601

require 'colorize'

HOST          = ""
ROOT_PATH     = Pathname.new('.')
BUILD_PATH    = Pathname.new('/tmp/brain')
LAYOUT_PATH   = Pathname.new('.layout')
INCLUDE_FILES = ['./.nojekyll'].map { |f| File.expand_path(f) }
MOTTO         = YAML.load_file('motto.yml')


module Brain
  class BrainFile
    attr_reader :content, :meta

    # Relative file path to the root
    def initialize(file_path)
      @path = Pathname.new(file_path)
      @content = File.read @path
      @meta    = Hashie::Mash.new
      read_meta_from_yaml_header
    end

    def src_path
      @src_path ||= ROOT_PATH.join(@path)
    end

    # URL is all lower-case.
    # it's case sensitive in Unix-like system
    def relative_dest_path
      @relative_dest_path ||= begin
        path = case ext
        when ".scss", ".slim"
          path_without_ext
        when ".md"
          path_without_ext.join('index.html')
        else
          @path
        end

        Pathname.new(path.to_s.downcase)
      end
    end

    def dest_path
      @dest_path ||= BUILD_PATH.join(relative_dest_path)
    end

    def url
      @url ||= Pathname.new('/').join(relative_dest_path.to_s.gsub(%r{(^|/)index\.html$}, '/'))
    end

    def ext
      @ext ||= @path.extname
    end

    def ext_name
      @ext_name ||= ext[1..-1]
    end

    def dirname
      @dirname ||= @path.dirname
    end

    def basename
      @basename ||= @path.basename
    end

    def basename_without_ext
      @basename_without_ext ||= @path.basename(ext)
    end

    def path_without_ext
      @path_without_ext ||= @path.sub_ext ''
    end

    def path_with_new_ext(new_ext)
      @path.sub_ext new_ext
    end

    private

    def read_meta_from_yaml_header
      header   = @content.match(/\A---\n(.*?)\n---\n\n(.*)\Z/m)
      if header
        @content = header[2]
        @meta    = Hashie::Mash.new YAML.load(header[1])
        @meta.category.downcase! rescue nil
      end
    rescue ArgumentError # images are not UTF-8
      nil
    end

    def method_missing(meth, *args, &blk)
      @meta[meth]
    end
  end


  # Category page for each folder
  class BrainCategory < BrainFile
    def initialize(name, articles)
      @path = Pathname.new("./#{name}/index.html.slim")
      @content = File.read(ROOT_PATH.join('memories/index.html.slim'))
      read_meta_from_yaml_header
      @meta = Hashie::Mash.new({
        title: name.capitalize,
        category: name,
        tagline: MOTTO[name],
        articles: articles,
        })
    end
  end


  class Scanner
    require 'hashie'

    def self.find_files(dir_path)
      Dir.glob("#{dir_path}/**/*")
         .select { |path| File.file?(path) }
         .map { |file_path| BrainFile.new(file_path) }
    end

    def self.scan
      # Layouts are `layout_name => layout_file.html.slim`
      @@layouts  = self.find_files(LAYOUT_PATH).inject({}) do |layouts, file|
        layouts[File.basename(file.src_path, ".html.slim")] = file
        layouts
      end

      # All else files
      @@files = self.find_files(ROOT_PATH) + INCLUDE_FILES.map { |f| BrainFile.new(f) }

      # Atom needs articles
      @@articles = @@files
        .reject { |f| f.category.nil? }
        .sort_by { |a| [ a.meta.created_at||Time.new(0), a.meta.updated_at||Time.new(0) ] }
        .reverse

      # Article is file with meta of category
      @@categories = @@articles.group_by { |f| f.category.downcase }
      @@files += @@categories.map { |name, articles| BrainCategory.new(name, articles) }

      self
    end

    def self.method_missing(meth, *args, &blk)
      class_variable_get("@@#{meth}") rescue nil
    end
  end

  class SlimEnv

    def initialize(file=nil)
      @file = file
    end

    def current_page
      @file
    end

    def include(name, options = {}, &block)
      Slim::Template.new { Scanner.layouts[name.to_s].content }.render(self, &block)
    end

    def partial(name, options = {}, &block)
      include("_#{name}", options, &block)
    end

    def options_str options
      options.map { |k,v| "#{k}=\"#{v}\"" }.join(" ")
    end

    def link_to name, url, options = {}
      "<a href='#{HOST}#{url}' #{options_str(options)}>#{name}</a>"
    end

    def image_tag name, options = {}
      "<img src='/assets/images/#{name}' #{options_str(options)} />"
    end

    def stylesheet_link_tag name
      "<link href='/assets/stylesheets/#{name}.css' media='screen' rel='stylesheet' type='text/css'>"
    end

    def javascript_include_tag name
      "<script src='/assets/javascripts/#{name}.js' type='text/javascript'></script>"
    end

    def title
      current_page && current_page.title || "Ranmocy's Garden"
    end

    def tagline
      current_page && (current_page.tagline || datestr(current_page.created_at)) || "My Brain, My Treasure."
    end

    def description
      if current_page.ext == '.md'
        content = current_page.content.gsub("\n", "")
        (content.length <= 100) ? content : "#{content[0...97]}..."
      else
        tagline
      end
    end

    def datestr(time)
      time && time.strftime('%b %d %Y')
    end

    def category_item(name)
      "#{name.capitalize}(#{categories[name].size})"
    end

    def groups
      {
        life: ["diary", "dream", "poem", ],
        idea: ["idea", "remark", "philosophy", ],
        work: ["tech", "piece", "translation", "novel"],
      }
    end

    def motto
      Hashie::Mash.new(MOTTO)
    end

    def method_missing(meth, *args, &blk)
      current_page.send(meth.to_s) || Scanner.send(meth) # return nil if no method
    end

  end

  class Generator
    require 'slim'
    require 'rdiscount'
    require "fileutils"

    def cleanup
      FileUtils.rm_r(BUILD_PATH, secure: true) if File.exists? BUILD_PATH
      FileUtils.mkdir_p(BUILD_PATH)
    end

    def write_file(dest_path, content)
      FileUtils.mkdir_p File.dirname(dest_path)
      File.open(dest_path, "w") { |f| f.write(content) }
    end

    def apply_layout(file, helper, content, layout: "default")
      if Scanner.layouts[layout]
        template = Slim::Template.new { Scanner.layouts[layout].content }
        content = template.render(helper) { content }
      end
      write_file(file.dest_path, content)
    end

    def generate_slim(file)
      helper = SlimEnv.new(file)
      res    = Slim::Template.new { file.content }.render(helper)
      apply_layout(file, helper, res)
      puts "#{file.url}".green
    end

    def generate_scss(file)
      FileUtils.mkdir_p file.dest_path.dirname
      res = `scss #{file.src_path} #{file.dest_path} 2>&1`
      puts $?.success? ? "#{file.url}".green : res.red
    end

    def generate_md(file)
      layout_name = file.meta['layout'] ||
        (file.category && Scanner.layouts[file.category.downcase]) && file.category.downcase ||
        "article"
      apply_layout file, SlimEnv.new(file), RDiscount.new(file.content).to_html, layout: layout_name
      puts "#{layout_name}: #{file.url}".green
    end

    def generate_file(file)
      cmd = "generate_#{file.ext_name}"
      if respond_to? cmd
        print "#{file.ext_name.upcase}: #{file.src_path} => "
        # skip partial scss files
        return puts "Skip" if file.dest_path.extname.empty?
        self.send cmd, file
      else
        puts "copying #{file.url} to #{file.dest_path}".yellow
        write_file(file.dest_path, file.content)
      end
    end

    def generate_all
      cleanup
      Scanner.scan.files.each { |file| generate_file(file) }
    end
  end

end
