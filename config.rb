require 'pathname'
require 'yaml'

require 'colorize'

HOST          = ""
PORT          = 33333
ROOT_PATH     = Pathname.new('.')
BUILD_PATH    = Pathname.new('/tmp/brain')
LAYOUT_PATH   = Pathname.new('./.layout')
INCLUDE_FILES = ['./.nojekyll'].map { |f| File.expand_path(f) }
MOTTO         = YAML.load_file('motto.yml')


module Brain
  class Server
    require "webrick"
    include WEBrick

    def call(guard_class, event, *args)
      case event
      when :start_end
        log_file = File.open('/tmp/brain.log', 'a+')
        @server = HTTPServer.new(DocumentRoot: BUILD_PATH,
                                 Port: PORT,
                                 AccessLog: [[log_file, AccessLog::COMBINED_LOG_FORMAT]],
                                 Logger: Log.new(log_file))
        puts "Server will run on http://localhost:#{PORT}".green
        Thread.new { @server.start }     # Let's Rock!
      when :stop_end
        @server.shutdown                 # shutdown with guard
      end
    end
  end


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
      @url ||= Pathname.new('/').join(if relative_dest_path.basename == 'index.html'
        dirname
      else
        relative_dest_path
      end)
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


  class BrainCategory < BrainFile
    def initialize(name, articles)
      @path = Pathname.new("./#{name}/index.html.slim")
      @content = File.read(ROOT_PATH.join('memories/index.html.slim'))
      read_meta_from_yaml_header
      @meta = Hashie::Mash.new({
        title: name.capitalize,
        category: name,
        motto: MOTTO[name],
        articles: articles,
        }).merge(@meta)
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
      metaclass = class << self; self; end
      metaclass.send(:define_method, :current_page) { file }
      metaclass.send(:define_method, :current_description) {
        unless file.ext == '.slim'
          content = file.content.gsub("\n", "")
          (content.length <= 100) ? content : "#{content[0...97]}..."
        end
      }
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

    def datestr(time)
      time && time.strftime('%b %d %Y')
    end

    def article_class
      category && category.downcase == "poem" ? "poem" : "articles"
    end

    def category_url(name)
      size = if name == 'motto'
        File.read('motto/index.html.slim').scan(/^\s+li\s/).size
      else
        categories[name].size rescue NoMethodError nil
      end

      "#{name.capitalize}(#{size})"
    end

    def groups
      {life: ["diary", "dream", "poem", ],
        idea: ["idea", "remark", "philosophy", ],
        work: ["tech", "piece", "translation"], }
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
      layout_name = file.meta["layout"] || layout
      puts "render layout #{layout_name} for #{file.url}".yellow
      if Scanner.layouts[layout_name]
        template = Slim::Template.new { Scanner.layouts[layout_name].content }
        content = template.render(helper) { content }
      end
      write_file(file.dest_path, content)
    end

    def generate_slim(file)
      helper = SlimEnv.new(file)
      res    = Slim::Template.new { file.content }.render(helper)
      apply_layout(file, helper, res)
    end

    def generate_scss(file)
      # skip partial scss files
      return puts "Skip #{file.src_path}" if file.dest_path.extname.empty?

      FileUtils.mkdir_p file.dest_path.dirname
      res = `scss #{file.src_path} #{file.dest_path} 2>&1`
      puts res.red unless $?.success?
    end

    def generate_md(file)
      apply_layout file, SlimEnv.new(file), RDiscount.new(file.content).to_html, layout: "article"
    end

    def generate_file(file)
      cmd = "generate_#{file.ext_name}"
      if respond_to? cmd
        puts "#{file.ext_name.upcase}: #{file.src_path}"
        self.send cmd, file
      else
        puts "copying #{file.url} to #{file.dest_path}".green
        write_file(file.dest_path, file.content)
      end
    end

    def run_on_modifications(args)
      path = Pathname.new(args.first)
      # if layout changes all files will be re-generated
      if path.expand_path == LAYOUT_PATH.expand_path
        run_on_start
      else
        file = BrainFile.new(path)
        generate_file(file)
      end
    end

    def run_on_start(args)
      cleanup
      Scanner.scan.files.each { |file| generate_file(file) }
    end

    def call(guard_class, event, *args)
      if respond_to? event
        send(event, args)
      else
        run_on_start(args)
      end
    end
  end

end
