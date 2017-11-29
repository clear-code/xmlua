# -*- ruby -*-

/^xmlua\.VERSION = "(.+?)"/ =~ File.read("xmlua.lua")
version = $1

desc "Tag for #{version}"
task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end
