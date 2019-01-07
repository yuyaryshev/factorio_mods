require("prototypes.item")
require("prototypes.recipe")

data:extend{
  {
    type = "custom-input",
    name = "ght-bluebuild-autobuild",
    key_sequence = "SHIFT + K",
    consuming = "none",
  }, {
    type = "custom-input",
    name = "ght-bluebuild-autodemo",
    key_sequence = "SHIFT + L",
    consuming = "none",
  }
}
