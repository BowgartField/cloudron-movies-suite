Pour trouver réseau cloudron
docker network ls

ensuite  pour voir ip des docker dans le network cloudron
docker network inspect cloudron

pour trouver nom des docker
docker ps - a

## NZBGET

copier le ficher de conf dans le dossier
mettre "chown -R cloudron config" sur le dossier de config dans /app/data
modifier le mainPath et le webuiPath et templatePath
