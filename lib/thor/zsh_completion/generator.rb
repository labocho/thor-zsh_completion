class Thor
  module ZshCompletion
    class Generator
      SUBCOMMAND_FUNCTION_TEMPLATE = ERB.new(File.read("#{File.dirname(__FILE__)}/template/subcommand_function.erb"), nil, "-")
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
          safe_name: secure_function_name("__#{name}"),
          description: nil,
          options: [],
          subcommands: subcommand_metadata(thor)
        }

        erb = File.read("#{File.dirname(__FILE__)}/template/main.erb")
        ERB.new(erb, nil, "-").result(binding)
      end

      private

      def secure_function_name(str)
        str.gsub(/[^a-z0-9_]/, '_u_')
      end

      def render_subcommand_function(subcommand, options = {})
        prefix = options[:prefix] || []

        source = []

        prefix = (prefix + [subcommand[:safe_name]])
        function_name = prefix.join("_")
        depth = prefix.size + 1

        source << SUBCOMMAND_FUNCTION_TEMPLATE.result(binding)
        subcommand[:subcommands].each do |subcommand|
          source << render_subcommand_function(subcommand, prefix: prefix)
        end
        source.join("\n").strip + "\n"
      end

      def subcommand_metadata(thor)
        thor.tasks.map do |(name, command)|
          if subcommand_class = thor.subcommand_classes[name]
            subcommands = subcommand_metadata(subcommand_class)
          else
            subcommands = []
          end
          cmd_name = command.name.gsub("_", "-")
          { name: cmd_name,
            safe_name: secure_function_name(cmd_name),
            usage: command.usage,
            description: command.description,
            options: thor.class_options.map{|_, o| option_metadata(o) } +
                     command.options.map{|(_, o)| option_metadata(o) },
            subcommands: subcommands
          }
        end
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
