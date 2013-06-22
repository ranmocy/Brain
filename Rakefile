require 'pathname'
require 'fileutils'
require 'jekyll'

REPONAME = "ranmocy/ranmocy"
ROOT_DIR  = Pathname.new('.').expand_path
POSTS_DIR = Pathname.new("_posts").expand_path
SITE_DIR = Pathname.new("_site").expand_path


namespace :site do
  desc "Cleanup"
  task :cleanup do
    FileUtils.rm_r(SITE_DIR) if SITE_DIR.exist?
    FileUtils.rm_r(POSTS_DIR) if POSTS_DIR.exist?
    FileUtils.mkdir(POSTS_DIR)
  end

  desc "Generate _posts"
  task :prepare => [:cleanup] do
    Dir["[^_]*/*.md"].each do |file|
      ord_file = ROOT_DIR.join(file)
      filename = ord_file.basename.to_s.gsub(/\s+/, '-')
      category = ord_file.dirname.basename
      new_file = POSTS_DIR.join("1991-05-11-#{filename}")

      fronter  = YAML.load_file(ord_file)

      # FileUtils.cp(ord_file, new_file)
      begin
        org_f    = File.open(ord_file, "r")
        target_f = File.open(new_file, "w")

        target_f.write org_f.readline
        target_f.write "layout: default\ndate: #{fronter["updated-at"].try(:to_date) || Date.today}\n"
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
