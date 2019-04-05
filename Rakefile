require 'hashie'
require_relative 'config.rb'

def run(cmd, name: cmd)
  result = `#{cmd} 2>&1`
  $? == 0 ? puts("Success: #{name}") : abort("Failed: #{name}\n$#{result}")
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
    `firebase --project ranmocy-me deploy` # it may requires terminal lines, safer to not redirect output
    run("git add .")
    run("git commit -m 'Updated at #{Time.now}.'")
    run("git push origin gh-pages:gh-pages")
  ensure
    run("git checkout master")
  end
end
