require 'semverly'

module Prpr
  module Action
    module Gemfile
      class Update < Base
        def call
          if files.map(&:filename).include? 'Gemfile.lock'
            head_versions.each do |name, version|
              old_version = base_versions[name]

              next unless version
              next unless old_version

              if version.major > old_version.major
                add_comment(name, 'major version changed!')
              end

              if version.minor > old_version.minor
                add_comment(name, 'minor version changed!')
              end

            end
          end
        end

        private

        def github
          Repository::Github.default
        end

        def add_comment(name, comment)
          github.create_pull_request_comment(repository_name, number, comment, head, 'Gemfile.lock', position(name))
        end

        def position(name)
          diff.lines.index { |line| line =~ /^\+\s*#{name}/ } || diff.lines.index { |line| line.include?(name) }
        end

        def files
          @files ||= github.pull_request_files(repository_name, number)
        end

        def diff
          @diff ||= files.find { |file| file[:filename] == 'Gemfile.lock' }[:patch]
        end

        def base_versions
          @base_versions ||= versions(base)
        end

        def head_versions
          @head_versions ||= versions(head)
        end

        def versions(ref)
          gem_specs(ref).map { |s| [s.name, SemVer.parse(s.version.to_s)] }.to_h
        end

        def gem_specs(ref)
          Bundler::LockfileParser.new(gemfile(ref)).specs
        end

        def gemfile(ref)
          Config::Github.new(repository_name, branch: ref).read('Gemfile.lock')
        end

        def base
          event.pull_request.base.sha
        end

        def head
          event.pull_request.head.sha
        end

        def number
          event.number
        end

        def repository_name
          event.repository.full_name
        end

        def env
          @env ||= Config::Env.default
        end

        def major_version_comment
          env[:major_version_comment] || ':eyes: major version is changed'
        end

        def minor_version_comment
          env[:minor_version_comment] || ':eyes: minor version is changed'
        end
      end
    end
  end
end
