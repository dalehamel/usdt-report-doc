require 'rake/testtask'

DOCKER_DIR='docker'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb'].exclude()
  t.verbose = true
end

namespace :report do

  desc 'Create doc to publish'
  task :init do
    puts `touch docs.md`
    puts `wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-linux.tar.gz`
    puts `wget https://github.com/owickstrom/pandoc-include-code/releases/download/v1.2.0.2/pandoc-include-code-linux-ghc8-pandoc-1-19.tar.gz`
    puts `tar -xvpf pandoc-2.7.2-linux.tar.gz`
    puts `tar -xvpf pandoc-include-code-linux-ghc8-pandoc-1-19.tar.gz`
    puts `mkdir -p .bin`
    puts `mv pandoc-2.7.2/bin/pandoc .bin/pandoc`
    puts `mv ./pandoc-include-code .bin/`
    puts `rm *.tar.gz`
    puts `rm -rf pandoc-2.7.2`
  end

  desc 'Publish the documents with pandoc'
  task :publish do
    ['html', 'pdf', 'epub' ].each do |doctype|
      puts `.bin/pandoc doc.md --toc --filter .bin/pandoc-include-code -s --highlight-style espresso  -o doc.#{doctype}`
    end
  end
end
