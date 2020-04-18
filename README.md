# Docker-Airflow

This repo contains a very lightly modified version of the widely used
[puckel/docker-airflow](https://hub.docker.com/r/puckel/docker-airflow) Docker
image. The substantive modification is that I have included the Python ldap3
package which cannot be installed when the container is instantiated from
behind our corporate firewall.

Contributions are welcome.
