require 'pathname'
require 'fileutils'

GITHUB_REPO = "git@github.com:ranmocy/ranmocy.github.io.git"
GITHUB_BRANCH = "master"
GITCAFE_REPO = "git@gitcafe.com:ranmocy/ranmocy.git"
GITCAFE_BRANCH = "gitcafe-pages"

ROOT_DIR  = Pathname.new('.').expand_path
SITE_DIR = Pathname.new(".built").expand_path
SILENT = ($VERBOSE) ? "" : ">/dev/null 2>/dev/null"


desc "Link everything to .site/"
task :link do
  Dir.chdir('.site/') do
    categories = ["Blog", "Diary", "Dream", "Idea", "Org", "Philosophy", "Piece", "Poem", "Remark", "Tech", "Young"]
    categories.each do |category|
      system("ln -s ../#{category}")
    end
  end
end

desc "Generate blog files"
task :generate do
  system("middleman build 2>/dev/null")
end

desc "Update sources"
task :upload do
  system("git push github master:source #{SILENT}") ? puts("Sourced to Github.") : puts("Failed sourcing to Github.")
  system("git push gitcafe master:master #{SILENT}") ? puts("Sourced to GitCafe.") : puts("Failed sourcing to GitCafe.")
end

desc "Generate and publish blog to Github and GitCafe"
task :publish => [:generate, :upload] do
  Dir.chdir SITE_DIR do
    system("git init #{SILENT}")
    system("git add --all #{SILENT}")
    message = "Site updated at #{Time.now.utc}"
    system("git commit -m #{message.shellescape} #{SILENT}") && puts("Commited.")
    system("git push #{GITHUB_REPO} master:#{GITHUB_BRANCH} --force #{SILENT}") ? puts("Published to Github.") : puts("Failed publishing to Github.")
    system("git push #{GITCAFE_REPO} master:#{GITCAFE_BRANCH} --force #{SILENT}") ? puts("Published to GitCafe.") : puts("Failed publishing to GitCafe.")
  end
end
