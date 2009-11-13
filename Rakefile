require 'rubygems'
require 'hoe'
require './lib/oembedder.rb'
require 'spec/rake/spectask'

Hoe.new('oembedder', Oembedder::VERSION) do |p|
  p.developer('Ben Askins', 'ben.askins@gmail.com')
end

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

task :test => :spec