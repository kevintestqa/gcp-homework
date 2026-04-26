resource "local_file" "favorite-food" {
  content  = "lentils, rice and chicken!  Very Panamanian"
  filename = "${path.module}/favoritefood.txt"
}