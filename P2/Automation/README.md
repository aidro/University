### Uitleg reverse proxy ###
Een reverse proxy vangt al het binnenkomend verkeer op en routeert het naar de juiste bestemming. De reverse proxy werkt eigenlijk als intermediair tussen verstuurder en ontvanger.
Veel reverse proxy applicaties, waaronder Caddy en Nginx beschikken over de mogelijkheid om automatisch *HTTP* verkeer intern om te bouwen naar *HTTPS*.

### Uitleg opzet reverse proxy ###
Geraadpleegde tutorial: https://shape.host/resources/load-balancing-microservices-with-nginx-in-docker-environment
1. Eerst beginnen we met het opzetten van een docker-compose bestand waarin we twee services aangeven: **microservice1** & **microservice2**.
   Deze services draaien een image vanuit mijn eigen repository waar een python-flask HTTP webserver draait over poort 5050. Door twee van deze
   containers op te spinnen kunnen we doormiddel van een Nginx het verkeer load balancen tussen beide containers.
2. Bij Nginx zijn er maar een aantal dingen die je aan hoeft te geven zodat er een 'reverse' proxy wordt opgesteld. Een http block vangt al het lokale http verkeer (poort 80) op en routeert
   het door via de 'upstream' server decleration.
3. Ik maak een Dockerfile aan zodat Nginx weet waar in de container de bestanden te vinden zijn.
4. Als laatste stap voegen we een Nginx service toe aan de originele docker-compose file.

Om de code te draaien, gebruiken je onderstaand commando:
```

docker-compose up -d --build

```

De *-d* parameter staat hier voor **detached** en houdt in dat de container op de achtergrond wordt opgestart. De *--build* parameter houdt in dat er een image wordt gebouwd van alle services in de docker-compose file.
