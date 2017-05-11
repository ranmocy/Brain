require 'hashie'
require_relative 'config.rb'

SILENT = verbose == true ? "" : ">/dev/null 2>/dev/null"

def run(cmd, name: cmd)
  system("#{cmd} #{SILENT}") ? puts("Success: #{name}") : abort("Failed: #{name}")
end

desc "Generate blog files"
task :generate do
  Brain::Generator.new.generate_all
end

desc "Generate and publish blog to Github"
task :publish => [:generate] do
  begin
    # Push master branch
    run("git checkout master")
    run('[ -n "$(git status --porcelain)" ] && exit 1 || exit 0', name: 'Ensure working dir is clean')
    run("git push origin master:master")

    # push gh-pages branch
    run("git checkout gh-pages")
    run("rm -r ./* || true")
    run("cp -r #{BUILD_PATH}/* .")
    run("mv cname c && mv c CNAME || true", name: 'Fix CNAME')
    run("git add .")
    run("git commit -m 'Updated at #{Time.now}.'")
    run("git push origin gh-pages:gh-pages")
    run("/usr/local/bin/firebase deploy")
  rescue StandardException => e
    require 'pry'; binding.pry
  ensure
    run("git checkout master")
  end
end
