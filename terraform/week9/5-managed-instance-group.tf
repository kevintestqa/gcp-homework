resource "google_compute_region_instance_group_manager" "satellite-mig" {
    base_instance_name = "satellite-mig"
    name = "satellite-mig"
    region = "us-west1"
    target_size = 4

    //Grabs the instance template url
    version {
        instance_template = google_compute_instance_template.satellite-vm-template.self_link
    }
}