module Pod
  module Generator
    class Header

      # Make array of pods from Podfile to which a plugin should be applied to
      def makePodsArrayToApplyPlugin
        result = []
        # open file and read contents
        podfile = File.read(Config.instance.podfile_path).lines
        key = "cocoapods-no-autoimports__pods"

        podfile.each do |line|
          if line.include?(key)
            array_content = line.match(/\[(.*)\]/)[1]
            array_content = array_content.gsub("'", "").split(",").map(&:strip)
            result = array_content
          end
        end

        result
      end

      # Removed the following lines:
      # result << "#ifdef __OBJC__\n"
      # result << generate_platform_import_header
      # result << "#else\n"
      # result << "#endif\n"
      def generate_without_platform_imports
        result = ""
        result << "#ifndef FOUNDATION_EXPORT\n"
        result << "#if defined(__cplusplus)\n"
        result << "#define FOUNDATION_EXPORT extern \"C\"\n"
        result << "#else\n"
        result << "#define FOUNDATION_EXPORT extern\n"
        result << "#endif\n"
        result << "#endif\n"
        result << "\n"
        result
      end

      def generate_platform_imports
        result = ""
        result << "#ifdef __OBJC__\n"
        result << generate_platform_import_header
        result << "#else\n"
        result << "#ifndef FOUNDATION_EXPORT\n"
        result << "#if defined(__cplusplus)\n"
        result << "#define FOUNDATION_EXPORT extern \"C\"\n"
        result << "#else\n"
        result << "#define FOUNDATION_EXPORT extern\n"
        result << "#endif\n"
        result << "#endif\n"
        result << "#endif\n"
        result << "\n"
        result
      end

      def generate(should_import_platforms: true)
        result = ""
        if should_import_platforms
          result = generate_platform_imports
        else
          result = generate_without_platform_imports
        end

        imports.each do |import|
          result << %(#import "#{import}"\n)
        end

        unless module_imports.empty?
          module_imports.each do |import|
            result << %(\n@import #{import})
          end
          result << "\n"
        end

        result
      end
    end

    class UmbrellaHeader < Header

      # Generates the contents of the umbrella header according to the included
      # pods.
      #
      # @return [String]
      #
      def generate
        pods_to_apply_plugin = makePodsArrayToApplyPlugin
        matched_target = pods_to_apply_plugin.include?(target.name)
        if matched_target
          result = super(should_import_platforms: false)
        else
          result = super
        end

        if matched_target
          puts "✍️  Applying cocoapods-no-autoimports plugin to #{target.name}"
        end

        result << "\n"

        result << <<-eos.strip_heredoc
        FOUNDATION_EXPORT double #{target.product_module_name}VersionNumber;
        FOUNDATION_EXPORT const unsigned char #{target.product_module_name}VersionString[];
        eos

        result << "\n"

        result
      end
    end

    class PrefixHeader < Header
      def generate
        spec_names = file_accessors.map { |accessor| accessor.spec.name }
        pods_to_apply_plugin = makePodsArrayToApplyPlugin
        matched_target = false
        
        spec_names.each do |spec_name|
          if pods_to_apply_plugin.include?(spec_name)
            matched_target = true
          end
        end

        if matched_target
          result = super(should_import_platforms: false)
        else
          result = super
        end

        unique_prefix_header_contents = file_accessors.map do |file_accessor|
          file_accessor.spec_consumer.prefix_header_contents
        end.compact.uniq

        unique_prefix_header_contents.each do |prefix_header_contents|
          result << prefix_header_contents
          result << "\n"
        end

        file_accessors.map(&:prefix_header).compact.uniq.each do |prefix_header|
          result << Pathname(prefix_header).read
        end

        result
      end
    end
  end
end
