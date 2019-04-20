# frozen_string_literal: true

require 'rake/testtask'

DOCKER_DIR = 'docker'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb'].exclude
  t.verbose = true
end

namespace :report do
  desc 'Create doc to publish'
  task :init do
    puts `mkdir -p docs output .bin`
    puts `[ ! -f .bin/pandoc ] && wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-linux.tar.gz && tar -xvpf pandoc-2.7.2-linux.tar.gz && mv pandoc-2.7.2/bin/pandoc .bin/ && mv pandoc-2.7.2/bin/pandoc-citeproc .bin/ && rm -rf pandoc-2.7.2 && rm -f *.tar.gz*`
    puts `[ ! -f .bin/pandoc-include-code ] && wget https://github.com/owickstrom/pandoc-include-code/releases/download/v1.2.0.2/pandoc-include-code-linux-ghc8-pandoc-1-19.tar.gz && tar -xvpf pandoc-include-code-linux-ghc8-pandoc-1-19.tar.gz && mv ./pandoc-include-code .bin/ && rm -f *.tar.gz*`
  end

  desc 'Publish the documents with pandoc'
  task :publish do
    %w[html pdf epub].each do |doctype|
      puts `.bin/pandoc docs/*.md --toc \
            --top-level-division=chapter \
            --metadata date="$( date +'%D %X %Z')" \
            --metadata link-citations=true \
            --bibliography=bibliography.yaml \
            --csl ieee-with-url.csl \
            #{"--template=./templates/GitHub.html5" if doctype == "html"} \
            --filter .bin/pandoc-citeproc \
            --filter .bin/pandoc-include-code -s --highlight-style espresso \
            -o output/doc.#{doctype}`
    end
  end
end

namespace :docker do
  task :build do
    system("docker build -t quay.io/dalehamel/usdt-report-doc .")
  end
  task :push do
    system("docker push quay.io/dalehamel/usdt-report-doc")
  end
  task :publish do
    system("docker exec usdt-report-doc ./scripts/ci-build.sh")
  end
end

task :rubocop do
  system("bundle exec rubocop --auto-correct */**.rb")
end
