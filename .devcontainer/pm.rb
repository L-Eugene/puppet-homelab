#!/usr/bin/env ruby

def mod(package, version = nil)
    cmd = "puppet module install #{package} --modulepath /local-test/ --ignore-dependencies"

    cmd = "#{cmd} --version #{version}" if version

    `#{cmd}`
end

File.read('Puppetfile').split("\n").each do |line|
    mod *line.split.map { |str| str.gsub(/^[,']*|[,']*$/, '') }[1..-1]
end