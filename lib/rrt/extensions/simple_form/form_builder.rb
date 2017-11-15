module RRT
  module SimpleForm
    module FormBuilderExtensions
      def cancel_button(*args)
        options = args.extract_options!
        url = options[:to] || :back
        template.link_to "Cancel", url, :class => "btn"
      end
    end
  end
end

SimpleForm::FormBuilder.send(:include, RRT::SimpleForm::FormBuilderExtensions)