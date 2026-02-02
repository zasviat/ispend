This directory contains .yaml mamifests to deploy application in kubernetes cluster (e.g. minikube)

- namespace.yaml - creates 'ispend' namespace, used for other k8s components
- postgresql.yaml - creates persisent volume claim. deployment and service for PostgreSQL
- backend.yaml - creates deployment and service for backend

The whole app can be deployed in kubernetes cluster using manage.sh script

Make it executable
`chmod +x k8s_manifests/manage.sh`

To deploy app, run:
`./k8s_manifests/manage.sh deploy`

To destroy app, run:
`./k8s_manifests/manage.sh destroy`
