# -*- ruby -*-

/^xmlua\.VERSION = "(.+?)"/ =~ File.read("xmlua.lua")
version = $1

desc "Tag for #{version}"
task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end

namespace :version do
  desc "Update version"
  task :update do
    new_version = ENV["VERSION"]
    if new_version.nil?
      raise "Specify new version as VERSION environment variable value"
    end

    xmlua_lua_content = File.read("xmlua.lua").gsub(/xmlua\.VERSION = ".+?"/) do
      "xmlua.VERSION = \"#{new_version}\""
    end
    File.open("xmlua.lua", "w") do |xmlua_lua|
      xmlua_lua.print(xmlua_lua_content)
    end

    rockspec_content = File.read("xmlua.rockspec").gsub(/package_version = ".+?"/) do
      "package_version = \"#{new_version}\""
    end
    File.open("xmlua.rockspec", "w") do |rockspec|
      rockspec.print(rockspec_content)
    end
  end
end
