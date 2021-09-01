# Main

# Create a random id
resource "random_id" "buildSuffix" {
  byte_length = 2
}