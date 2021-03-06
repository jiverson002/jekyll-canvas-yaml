module Canvas
  module Workflow
    module Tags
      class AssignmentTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
          super
          @title = text.strip
        end

        def render(context)
          config = context.registers[:site].config['canvas']
          if @title.to_s.empty?
            title = context.environments.first['page']['title']
          else
            title = @title
          end
          course = config['course']
          client = Canvas::Workflow::Client.new(config)

          assignments = client.list_assignments(course, :search_term => title).to_a

          raise ArgumentError.new("Assignment '#{title}' does not exist") if assignments.empty?

          # return the first (according to order returned by pandarus)
          # assignment with the correct name
          assignments.select { |a| a[:name].strip == title }.first[:id]
        end
      end
    end
  end
end

Liquid::Template.register_tag('assignment', Canvas::Workflow::Tags::AssignmentTag)
