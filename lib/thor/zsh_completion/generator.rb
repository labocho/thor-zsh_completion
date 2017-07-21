require "set"

class Thor
  module ZshCompletion
    class Generator
      SUBCOMMAND_FUNCTION_TEMPLATE = ERB.new(File.read("#{File.dirname(__FILE__)}/template/subcommand_function.erb"), nil, "-")
      IGNORED_MAP_COMMANDS = %w(-? -D --help -h).freeze
      attr_reader :thor, :name

      def initialize(thor, name)
        @thor = thor
        @name = name
      end

      def generate
        # Format command information like below:
        #
        # { name: "__iterm",
        #   options: [],
        #   subcommands: [
        #     { name: "list-sessions",
        #       description: "List name of all sessions in current terminal",
        #       options: [],
        #       subcommands: [],
        #     },
        #     { name: "new-session",
        #       description: "Create new session in current terminal",
        #       options: [
        #         { names: ["--name", "-n"],
        #           description: nil,
        #         },
        #       ],
        #       subcommands: [],
        #     },
        #     { name: "sessions",
        #       description: "Manage sessions by .iterm-sessions",
        #       options: [],
        #       subcommands: [
        #         { name: "start",
        #           description: "Start all sessions if it's not started",
        #           options: [],
        #           subcommands: [],
        #         }
        #       ]
        #     }
        #   ]
        # }

        main = {
          name: "__#{name}",
          description: nil,
          options: [],
          subcommands: subcommand_metadata(thor)
        }

        @rendered_function_names = Set.new

        erb = File.read("#{File.dirname(__FILE__)}/template/main.erb")
        ERB.new(erb, nil, "-").result(binding)
      end

      private
      def render_subcommand_function(subcommand, options = {})
        prefix = options[:prefix] || []

        source = []

        prefix = (prefix + [subcommand[:name]])
        function_name = prefix.join("_")
        depth = prefix.size + 1

        return '' if @rendered_function_names.include?(function_name)

        source << SUBCOMMAND_FUNCTION_TEMPLATE.result(binding)

        @rendered_function_names << function_name

        subcommand[:subcommands].each do |subcommand|
          source << render_subcommand_function(subcommand, prefix: prefix)
        end
        source.join("\n").strip + "\n"
      end

      def subcommand_metadata(thor)
        result = []
        thor.tasks.each do |(name, command)|
          result << generate_command_information(thor, name, command)
        end
        thor.map.each do |_alias, name|
          next if IGNORED_MAP_COMMANDS.include?(_alias.to_s)
          next unless command = thor.tasks[name.to_s.gsub('-', '_')]
          result << generate_command_information(thor, _alias, command)
        end
        result.uniq!{|info| info[:name] }
        result
      end

      def generate_command_information(thor, name, command)
        if subcommand_class = thor.subcommand_classes[name]
          subcommands = subcommand_metadata(subcommand_class)
        else
          subcommands = []
        end
        { name: name.gsub("_", "-"),
          usage: command.usage,
          description: command.description,
          options: thor.class_options.map{|_, o| option_metadata(o) } +
                   command.options.map{|(_, o)| option_metadata(o) },
          subcommands: subcommands
        }
      end

      def option_metadata(option)
        { names: ["--#{option.name}"] + option.aliases.map{|a| "-#{a}" },
          description: option.description,
        }
      end

      def quote(s)
        escaped = s.gsub(/'/, "''")
        %('#{escaped}')
      end

      def bracket(s)
        %([#{s}])
      end

      def escape_option_names(names)
        if names.size == 1
          names.first
        else
          "{" + names.join(",") + "}"
        end
      end
    end
  end
end
