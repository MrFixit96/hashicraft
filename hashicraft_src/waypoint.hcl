
project = "hashicraft"

app "hashicraft" {
    build {
        use "docker" {
            buildkit    = false
            disable_entrypoint = false
        }
    }

    deploy {
        use "nomad-jobspec" { 
            jobspec = templatefile("${path.app}/hashicraft.nomad")
        }
    }

}
