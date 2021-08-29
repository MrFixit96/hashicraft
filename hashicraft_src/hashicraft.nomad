job "hashicraft"{
    region = "us-west-2"
    datacenters = ["us-west-2a"]
    priority = 80
    group "mc-server" {
        task "minecraft" {
            resources {
                cpu = 5000
                memory = 5000
                disk = 2000
                network {
                    port "access" {
                        static = 25565
                    }
                }
            }
            //eula required otherwise runtime will fail to start
            artifact {
                source = "https://raw.githubusercontent.com/pandom/cloud-nomad/master/minecraft/common/eula.txt"
                mode = "file"
                destination = "eula.txt"
            }
            artifact {
                source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
                mode = "file"
                destination = "server.jar"
            }
            driver = "java"

            config {
                jar_path    = "server.jar"
                jvm_options = ["-Xmx768M", "-Xms768M"]
                args = ["EULA=true", "nogui"]
            }
        }
    }
}