module Pod
    module Generator
      class Header

        # Removed the following lines:
        # result << "#ifdef __OBJC__\n"
        # result << generate_platform_import_header
        # result << "#else\n"
        # result << "#endif\n"

        def generate
            result = ''
            result << "#ifndef FOUNDATION_EXPORT\n"
            result << "#if defined(__cplusplus)\n"
            result << "#define FOUNDATION_EXPORT extern \"C\"\n"
            result << "#else\n"
            result << "#define FOUNDATION_EXPORT extern\n"
            result << "#endif\n"
            result << "#endif\n"
            result << "\n"
    
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
    end
  end