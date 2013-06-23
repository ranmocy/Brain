require 'time'
require 'pathname'
require 'fileutils'
require 'jekyll'

REPONAME = "ranmocy/ranmocy"
ROOT_DIR  = Pathname.new('.').expand_path
POSTS_DIR = Pathname.new("_posts").expand_path
SITE_DIR = Pathname.new("_site").expand_path

def parse_fronter(path)
  raw    = File.read(path)
  chunks = raw.split(/^(-{5}|-{3})\s*$/, 3)

  if (chunks.length == 5)
    meta     = YAML.safe_load(chunks[2].strip)
    contents = chunks[4].strip
  else
    meta     = {}
    contents = raw
  end

  meta
end

namespace :site do
  desc "Cleanup"
  task :cleanup do
    FileUtils.rm_r(SITE_DIR) if SITE_DIR.exist?
    FileUtils.rm_r(POSTS_DIR) if POSTS_DIR.exist?
    FileUtils.mkdir(POSTS_DIR)
  end

  desc "Generate _posts by files end with md"
  task :prepare => [:cleanup] do
    Dir["[^_]*/*.md"].each do |file|
      ord_file = ROOT_DIR.join(file)
      category = ord_file.dirname.basename

      fronter  = parse_fronter(ord_file.to_s)
      date = Time.parse(fronter["created-at"]).to_date

      filename = ord_file.basename.to_s.gsub(/\s+/, '-') # escape
      new_file = POSTS_DIR.join("#{date.to_s}-#{filename}")

      # Fixup Fronter
      begin
        org_f    = File.open(ord_file, "r")
        target_f = File.open(new_file, "w")

        target_f.write org_f.readline
        target_f.write "layout: default\n"
        target_f.write "date: #{date}\n"
        target_f.write org_f.read
      ensure
        org_f.close
        target_f.close
      end
    end
  end

  desc "Generate blog files"
  task :generate => [:prepare] do
    Jekyll::Site.new(Jekyll.configuration({
      "source"      => ".",
      "destination" => "_site"
    })).process
  end


  desc "Generate and publish blog to gitcafe-pages"
  task :publish => [:generate] do
    Dir.mktmpdir do |tmp|
      cp_r "_site/.", tmp
      Dir.chdir tmp
      system "git init"
      system "git add ."
      message = "Site updated at #{Time.now.utc}"
      system "git commit -m #{message.shellescape}"
      system "git remote add origin git@gitcafe.com:#{REPONAME}.git"
      system "git push origin master:gitcafe-pages --force"
    end
  end
end
