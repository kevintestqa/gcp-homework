resource "local_file" "favorite-food" {
  content  = "Lentils, rice and chicken!  Very Panamanian"
  filename = "${path.module}/favoritefood.txt"
}