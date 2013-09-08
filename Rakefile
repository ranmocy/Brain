require 'pathname'
require 'fileutils'

GITHUB_REPO = "git@github.com:ranmocy/ranmocy.github.io.git"
GITHUB_BRANCH = "master"
GITCAFE_REPO = "git@gitcafe.com:ranmocy/ranmocy.git"
GITCAFE_BRANCH = "gitcafe-pages"

ROOT_DIR  = Pathname.new('.').expand_path
SITE_DIR = Pathname.new(".site").expand_path
BUILT_DIR = Pathname.new(".built").expand_path
SILENT = ($VERBOSE) ? "" : ">/dev/null 2>/dev/null"


desc "Articles statistics"
task :stat do
  ['en', 'zh'].each do |lang|
    puts "#{lang}:"
    categories = Dir.glob("#{lang}/*").map{ |_| _.split('/').last }
    width = categories.map(&:length).max
    sizes = categories.map{ |c| Dir.glob("#{lang}/#{c}/*").size }
    categories.zip(sizes).map{ |c| printf "  %#{width}s %#{2}s\n", c[0].split('/').last, c[1]}
  end
end

desc "Link everything to .site/, base on lang"
task :link, [:lang] do |t, args|
  args.with_defaults(lang: 'zh')
  lang = args[:lang]

  Dir.chdir(SITE_DIR) do
    puts "Clean old symlinks: #{Dir['*'].map{ |d| Pathname.new(d) }.select(&:symlink?).map(&:unlink).size}"
    puts "Add new symlinks of #{lang}: #{Dir["../#{lang}/*"].each{ |category| system("ln -s ../#{lang}/#{category}") }.size}"
  end
end

desc "Generate blog files"
task :generate, [:lang] do |t, args|
  args.with_defaults(lang: 'zh')
  lang = args[:lang]
  Rake::Task["link"].reenable
  Rake::Task["link"].invoke(lang)
  puts system("middleman build 2>/dev/null") ? "Successfully built #{lang}" : "Failed built #{lang}"
end

desc "Update sources"
task :upload do
  system("git push github master:source #{SILENT}") ? puts("Sourced to Github.") : puts("Failed sourcing to Github.")
  system("git push gitcafe master:master #{SILENT}") ? puts("Sourced to GitCafe.") : puts("Failed sourcing to GitCafe.")
end

desc "Generate and publish blog to Github and GitCafe"
task :publish, [:lang] => [:upload] do |t, args|
  args.with_defaults(lang: 'all')
  langs = args[:lang]=='all' ? Dir['*/'].map{ |l| l[0...-1] } : [args[:lang]]

  langs.each do |lang|
    Rake::Task["generate"].reenable
    Rake::Task["generate"].invoke(lang)

    Dir.chdir BUILT_DIR do
      system("git init #{SILENT}")
      system("git add --all #{SILENT}")
      message = "Site updated at #{Time.now.utc}"
      system("git commit -m #{message.shellescape} #{SILENT}") && puts("Commited.")

      res = false
      case lang
      when 'en'
        res = system("git push #{GITHUB_REPO} master:#{GITHUB_BRANCH} --force #{SILENT}")
      when 'zh'
        res = system("git push #{GITCAFE_REPO} master:#{GITCAFE_BRANCH} --force #{SILENT}")
      else
        warn "No idea of how to pubilsh #{lang}"
      end
      res ? puts("Successfully published #{lang}") : warn("Failed published #{lang}")
    end
  end
end
