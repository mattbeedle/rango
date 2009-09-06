#!/usr/bin/env ruby1.9
# encoding: utf-8

require "rango"

Rango.boot

# dependencies
# Rango.dependency "dm-core", github: "datamapper/dm-core"
# Rango.dependency "pupu", github: "botanicus/pupu", as: "pupu/adapters/rango"
Rango.dependency "haml", github: "nex3/haml"

if Dir.exist?("gems")
  Gem.path.clear
  Gem.path.push(Project.path.join("gems").to_s)
end

require_relative "settings"

# database connection
# DataMapper.setup(:default, "sqlite3::memory")

# if you will run this script with -i argument, interactive session will begin
Rango.interactive if ARGV.delete("-i")
