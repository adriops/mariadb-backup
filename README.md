# MariaDB lightweight image for database backups

## Variables
It's mandatory to pass this environment variables:

| Variables | Use                                   | Example     |
|:---------:|:--------------------------------------|:-----------:|
| `DB_HOST` | Define the MariaDB host               | `localhost` |
| `DB_USER` | Define the user to connect            | `operator`  |
| `DB_PASS` | Define the password of the user       | `p455W0rD`  |
| `BK_PATH` | Path to save backups (default `/mnt`) | `/mnt`      |

## Usage

### Run on single docker container
You can run it loading variables from `env.sample` file included:
```
docker run -v $(pwd)/tmp:/var/data --env-file env.sample  mariadb-backup:0.1.0 db1 db2 dbX
```

### Run as CronJob on kubernetes cluster
You can load it as `CronJob` in your cluster and attach a volume:  

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-backups
  namespace: testing
  labels:
    app.kubernetes.io/name: mariadb-backups
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
```

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mariadb-backups-config
  namespace: testing
data:
  DB_HOST: "localhost"
  DB_USER: "my_user"
  BK_PATH: "/mnt"
```

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mariadb-backup
  namespace: testing
  labels:
    app.kubernetes.io/name: mariadb-backups
spec:
  schedule: "0 3 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: mariadb-backup
            image: sevenops/mariadb-backup:0.1.0
            imagePullPolicy: IfNotPresent
            args:
            - db_name_1
            - db_name_2
            - db_name_X
            envFrom:
            - configMapRef:
                name: mariadb-backups-config
            env:
            - name: DB_PASS
              valueFrom:
                secretKeyRef:
                  name: mariadb-secrets
                  key: mariadb-password
            volumeMounts:
            # Be sure that you are mounting the same directory that you put in BK_PATH variable
            - mountPath: "/mnt"
              name: db-backups
          restartPolicy: OnFailure
          automountServiceAccountToken: false
          volumes:
          - name: db-backups
            persistentVolumeClaim:
              claimName: db-backups
```
Test it:
```
kubectl create job -n testing --from=cronjob/mariadb-backup mariadb-backup-testing
```
