resource "google_compute_region_instance_group_manager" "satellite-2x-mig" {
    base_instance_name = "satellite-2x"
    name = "satellite-2x-mig"
    region = "us-west1"
    target_size = 2
    //Grabs the instance template url
    version {
        instance_template = google_compute_instance_template.satellite-2x-vm-template.self_link
    }
}