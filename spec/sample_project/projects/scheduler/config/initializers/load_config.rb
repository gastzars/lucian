Dir.glob(File.join(Rails.root, "config/apps/*.yaml")).sort.each do |directory|
  name = directory.scan(/apps\/(.*).yaml/).join.classify
  Rails.application.class.parent.const_set(name,HashWithIndifferentAccess.new(
    YAML.load(
      ERB.new(
        File.read(directory)
      ).result
    )[Rails.env])
  )
end

Dir.glob(File.join(Rails.root, "config/apps/*.yml")).sort.each do |directory|
  name = directory.scan(/apps\/(.*).yml/).join.classify
  Rails.application.class.parent.const_set(name,HashWithIndifferentAccess.new(YAML.load_file(directory)[Rails.env]))
end
