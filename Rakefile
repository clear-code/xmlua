# -*- ruby -*-

/^xmlua\.VERSION = "(.+?)"/ =~ File.read("xmlua.lua")
version = $1

desc "Tag for #{version}"
task :tag do
  sh("git", "tag", "-a", version, "-m", "#{version} has been released!!!")
  sh("git", "push", "--tags")
end

desc "Upload package to luarocks.org"
task :upload do
  api_key = ENV["API_KEY"]
  if api_key.nil?
    raise "Specify API key as API_KEY environment variable value"
  end

  rockspec_version = ""
  File.open("xmlua.rockspec") do |rockspec|
    rockspec.each_line do |line|
      case line
      when /package_version = "(.+?)"/
        rockspec_version << $1
      when /version = package_version \.\. "(.+?)"/
        rockspec_version << $1
      end
    end
  end
  versioned_rockspec_filename = "xmlua-#{rockspec_version}.rockspec"

  begin
    cp("xmlua.rockspec", versioned_rockspec_filename)
    sh("luarocks",
       "upload",
       "--api-key=#{api_key}",
       versioned_rockspec_filename)
  ensure
    rm_f(versioned_rockspec_filename)
  end
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
