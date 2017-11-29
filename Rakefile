# -*- ruby -*-

/^xmlua\.VERSION = "(.+?)"/ =~ File.read("xmlua.lua")
version = $1

task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end
