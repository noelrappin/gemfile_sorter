RSpec.describe "Acceptance Tests", :slow do
  specify { expect("basic_gems").to be_correctly_sorted }
  specify { expect("gems_with_versions").to be_correctly_sorted }
  specify { expect("duplicate_gems").to be_correctly_sorted }
  specify { expect("gems_with_comments").to be_correctly_sorted }
  specify { expect("commented_gem").to be_correctly_sorted }
  specify { expect("leading_comments").to be_correctly_sorted }
  specify { expect("trailing_comments").to be_correctly_sorted }
  specify { expect("basic_gems_with_header").to be_correctly_sorted }
  specify { expect("basic_group").to be_correctly_sorted }
  specify { expect("group_with_duplicates").to be_correctly_sorted }
  specify { expect("inline_groups").to be_correctly_sorted }
  specify { expect("basic_source").to be_correctly_sorted }
  specify { expect("duplicate_source").to be_correctly_sorted }

  # inline source declarations
  # source with group
  # group with source
  # inline with both
end
