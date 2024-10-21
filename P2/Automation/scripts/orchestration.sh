function install_docker() {

    hosts=("10.24.49.200" "10.24.49.201" "10.24.49.202")
    cluster=($(pvecm status | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}'))

    if ! command -v docker &>/dev/null; then
        apt-get update
        apt-get install -y docker.io docker-compose
    fi

    # Initialiseer het Swarm network
    docker swarm init --advertise-addr "${cluster[0]}"

    # Extract de manager en worker tokens
    manager_token=$(docker swarm join-token manager | grep -o 'SWMTKN[^ ]*')
    worker_token=$(docker swarm join-token worker | grep -o 'SWMTKN[^ ]*')

    # Verbing elke server in het cluster zodat ze het Swarm network joinen
    for ip in "${cluster[@]:1}"
    do
        echo "Connecting to $ip"
        sleep 1
        ssh -t root@"$ip" "apt-get install -y docker.io docker-compose && docker swarm join --token $manager_token ${cluster[0]}:2377"
    done

    for ip in "${hosts[@]}"
    do
        echo "Connecting to $ip"
        sleep 1
        ssh -t root@"$ip" "
            # Check of Docker is geinstalleerd
            if ! command -v docker &>/dev/null; then
                apt-get update
                apt-get install -y docker.io docker-compose
            fi

            # Clone de Git repo
            if [ ! -d \"University\" ]; then
                git clone https://github.com/aidro/University.git
            fi
            cd University && git checkout cloud

            # Bouw de docker image met compose, detached van cli
            cd P2/Automation
            docker-compose up -d --build

            docker-compose logs

            echo "Hierboven de container logs! ^^^ " 

            sleep 3

            # Laat de client het Swarm network joinen
            docker swarm join --token $worker_token ${cluster[0]}:2377
            "
        done

        docker node ls

        # Maak een sample service: it be working! :)
        docker service create --name helloworld alpine ping docker.com
        docker service ls

        sleep 5
}