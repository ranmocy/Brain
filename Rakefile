require 'hashie'
load 'config.rb'

SILENT = ($VERBOSE) ? "" : ">/dev/null 2>/dev/null"
Github = Hashie::Mash.new({
  name: 'github',
  url: 'git@github.com:ranmocy/ranmocy.github.io.git',
  source_branch: 'source',
  publish_branch: 'master',
  })
GitCafe = Hashie::Mash.new({
  name: 'gitcafe',
  url: 'git@gitcafe.com:ranmocy/ranmocy.git',
  source_branch: 'master',
  publish_branch: 'gitcafe-pages',
  })
SOURCES = [Github, GitCafe]

def cmd(s, name: nil)
  system("#{s} #{SILENT}") ? puts("Success: #{name}") : abort("Failed: #{name}")
end


desc "Generate blog files"
task :generate do
  Brain::Generator.new.call(self, :start_begin)
end

desc "Update sources"
task :upload, [:force] do |t, args|
  git_args = args[:force] ? '-f' : ''

  SOURCES.each do |s|
    cmd("git push #{s.url} master:#{s.source_branch} #{git_args}",
        name: "Source to #{s.name.capitalize}.")
  end
end

desc "Generate and publish blog to Github and GitCafe"
task :publish => [:generate, :upload] do
  Dir.chdir BUILD_PATH do
    cmd("mv cname c && mv c CNAME || true", name: 'Fix CNAME')
    cmd("git init && git add --all", name: 'Init repo')
    message = "Site updated at #{Time.now.utc}"
    cmd("git commit -m #{message.shellescape}", name: "Commit")

    SOURCES.each do |s|
      cmd("git push #{s.url} master:#{s.publish_branch} --force",
          name: "Publishing #{s.name.capitalize}")
    end
  end
end
