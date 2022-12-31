## Helm chart for canal 

[canal](https://github.com/alibaba/canal) 用途是基于 MySQL 数据库增量日志解析，提供增量数据订阅和消费   
目前基于 release [1.16-hotfix](https://github.com/alibaba/canal/releases/tag/canal-1.1.6-hotfix-1) 编译后的java 字节码 构建镜像 运行时是 alpine + openjdk11  
支持直接在helm 中配置 server 配置和instance配置(部分)

### Prerequisites
Kubernetes 1.20+  
Helm 3.0+  

### Usage
```
helm repo add zengzhengrong https://zengzhengrong.github.io/helm-charts
helm repo update
```

#### Single 单节点
```
helm install canal zengzhengrong/canal --namespace canal \
    --set canalAdmin.logs.storageClass=openebs-hostpath \
    --set canalServer.logs.storageClass=openebs-hostpath 
```

#### HA 集群模式

安装内置的zookeeper集群
```
helm install canal zengzhengrong/canal --namespace canal \
    --set canalAdmin.ingress.enabled=true \
    --set canalServerClusterMode.enabled=true \
    --set zookeeper.enabled=true \
    --set zookeeper.volume.storageClassName=openebs-hostpath 
```

连接外部zookeeper

```
helm install canal zengzhengrong/canal --namespace canal \
    --set canalAdmin.ingress.enabled=true \
    --set canalServerClusterMode.enabled=true \
    --set zookeeper.extralUrl=zookeeper.zookeeper
```
## Parameters 

Ref: [values.yaml](https://github.com/zengzhengrong/canal-helm/blob/main/canal/values.yaml)

| **Name**                           | **Default Value**              | **Description**                                                                               |
|------------------------------------|--------------------------------|-----------------------------------------------------------------------------------------------|
| `canalAdmin.replicaCount`                 | 1                             | canal admin 副本数        |
| `canalAdmin.image`                 | zengzhengrong889/canal_admin:v1.16_hotfix                             | canal admin镜像       |
| `canalAdmin.pullPolicy`                 | IfNotPresent                              | canal admin镜像拉取策略       |
| `canalAdmin.restartOnConfigMapChange`                 | true                              | 是否当configmap 变更时 canal admin  重启 (仅针对helm生成的configmap)      |
| `canalAdmin.config.base.extralConfigMapRef`                 | ""                              | 引用外部的configmap的名字，空字符串则使用helm的配置       |
| `canalAdmin.config.base.canalAdminUser`                 | "admin"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.base.canalAdminPasswd`                 | "admin"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.base.serverPort`                 | "8089"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.base.springDatasourceAddress`                 | "sample-leader.radondb-mysql"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.base.springDatasourceUsername`                 | "super_user"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.base.springDatasourceDatabase`                 | "canal_manager"                              | canal admin 的 application.yml 配置 [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-QuickStart)       |
| `canalAdmin.config.initsql.extralConfigMapRef`                 | ""                              | 引用外部configmap来初始化admin的sql,空的话则使用内部helm生成的    |
| `canalAdmin.secret.extralPasswordSecretRef`                 | ""                              | 引用外部secret来代替的内置数据库明文密码，空的话会使用下面的明文密码    |
| `canalAdmin.secret.springDatasourcePassword`                 | "RadonDB@123"                              | admin需要的连接数据库密码    |
| `canalAdmin.extralEnv`                 | {}                              | key-value 为canal admin 启动时添加额外环境变量    |
| `canalAdmin.resources.requests.cpu`                 | 500m                             | requests cpu    |
| `canalAdmin.resources.requests.memory`                 | 1Gi                             | requests memory    |
| `canalAdmin.resources.limits.cpu`                 | "1"                            | limits cpu    |
| `canalAdmin.resources.limits.memory`                 | 1Gi                            | limits memory    |
| `canalAdmin.logs.storageClass`                 | openebs-hostpath                            | logs storageClass    |
| `canalAdmin.logs.storageSize`                 | 10Gi                           | logs storageSize    |
| `canalAdmin.logs.volumeMode`                 | Filesystem                           | logs volumeMode    |
| `canalAdmin.logs.accessModes`                 | [ReadWriteOnce]                           | logs accessModes    |
| `canalAdmin.localtimeHostPath.enabled`                 | true                          | If use host path mount localtime   |
| `canalAdmin.service.type`                 | ClusterIP                           | admin service type  |
| `canalAdmin.service.nodePort`                 | ""                           | specify nodeport if type "NodePort"   |
| `canalAdmin.ingress.enabled`                 | true                           | if enabled ingress or not  |
| `canalAdmin.ingress.className`                 | "nginx"                           | specify ingress className default ingress-nginx  |
| `canalAdmin.ingress.annotations`                 | {}                           | specify ingress annotations  |
| `canalAdmin.ingress.host`                 | canal-admin.localhost                           | specify ingress host  |
| `canalAdmin.ingress.tls`                 | []                           | specify ingress tls  |
| `canalAdmin.nodeSelector`                 | {}                           | specify nodeSelector  |
| `canalAdmin.tolerations`                 | []                           | specify tolerations  |
| `canalAdmin.affinity`                 | {}                           | specify affinity  |
| `canalServer.replicaCount`                 | 2                           | specify affinity  |
| `canalServer.image`                 | zengzhengrong889/canal_server:v1.16_hotfix                           | canal server image  |
| `canalServer.pullPolicy`                 | IfNotPresent                           | canal server image pullPolicy |
| `canalServer.restartOnConfigMapChange`                 | true                           | canal server 当configmap 改变时一起重启 |
| `canalServer.config.extralConfigMapRef`                 | ""                           | canal server 引用外部configmap |
| `canalServer.config.canalRegisterIp`                 | ""                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminManager`                 | "canal-admin"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminPort`                 | "11110"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminUser`                 | "admin"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminRegisterAuto`                 | "true"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminRegisterCluster`                 | "local"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.config.canalAdminRegisterName`                 | ""                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.secret.extralPasswordSecretRef`                 | ""                           | canal server 引用外部password的secret，不填则使用如下配置 |
| `canalServer.secret.canalAdminPasswd`                 | "4ACFE3202A5FF5CF467898FC58AAB1D615029441"                           | canal server 的 canal_local.properties [参考](https://github.com/alibaba/canal/wiki/Canal-Admin-ServerGuide) |
| `canalServer.extralEnv`                 | {}                              | key-value 为canal server 启动时添加额外环境变量    |
| `canalServer.resources.requests.cpu`                 | 100m                             | requests cpu    |
| `canalServer.resources.requests.memory`                 | 512Mi                             | requests memory    |
| `canalServer.resources.limits.cpu`                 | "500m"                            | limits cpu    |
| `canalServer.resources.limits.memory`                 | 2Gi                            | limits memory    |
| `canalServer.logs.storageClass`                 | openebs-hostpath                            | logs storageClass    |
| `canalServer.logs.storageSize`                 | 10Gi                           | logs storageSize    |
| `canalServer.logs.volumeMode`                 | Filesystem                           | logs volumeMode    |
| `canalServer.logs.accessModes`                 | [ReadWriteOnce]                           | logs accessModes    |
| `canalServer.localtimeHostPath.enabled`                 | true                          | If use host path mount localtime   |
| `canalServer.service.type`                 | ClusterIP                           | admin service type  |
| `zookeeper.enabled`                 | false                           | 是否开启内置zookeeper 额外配置请参考 https://github.com/zengzhengrong/zookeeper/blob/main/helm/values.yaml   |
| `zookeeper.replicaCount`                 | 1                           | 内置zookeeper 的节点数  |
| `zookeeper.image.repository`                 | "hypertrace/zookeeper"                           | zookeeper 镜像仓库  |
| `zookeeper.image.tagOverride`                 | latest                           | zookeeper 镜像仓库tag  |
| `zookeeper.volume.storageClassName`                 | openebs-hostpath                           | zookeeper 的 storageClassName |
| `zookeeper.volume.storage`                 | 10Gi                           | zookeeper 的 storage  |
| `zookeeper.extralUrl`                 | ""                           | 外置zookeeper的地址  |
| `canalServerClusterMode.enabled`                 | false                           | 是否开启集群HA模式  |
| `canalServerClusterMode.mode`                 | tcp                           | 默认tcp，可选"rocketMQ"，目前支持直接在helm values 配置 rocketMQ，其他消息队列的话先配置用默认tcp然后再到canal admin里的主配置进行修改 |
| `canalServerClusterMode.config.rocketmq.producerGroup`                 | canal_group                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.enableMessageTrace`                 | false                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.customizedTraceTopic`                 | null                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.namespace`                 | null                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.namesrvAddr`                 | rocketmq-namesrv-hl.rocketmq:9876                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.retryTimesWhenSendFailed`                 | 1                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.vipChannelEnabled`                 | true                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `canalServerClusterMode.config.rocketmq.tag`                 | canal                           | 如果canalServerClusterMode.mode 为rocketMQ, 则该配置生效，[配置参考](https://github.com/alibaba/canal/wiki/Canal-Kafka-RocketMQ-QuickStart)   |
| `defaultSampleCanalInstance.enabled`                 | false                           | 是否开启instance.propertios 的配置，如果为true 则可以直接在helm配置如下参数，[配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.name`                 | radondb                           | instance 名称[配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceMasterAddress`                 | sample-leader.radondb-mysql:3306                           | instance 监听的mysql数据库地址[配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceTsdbEnable`                 | true                           | 是否开启 instance tsdb [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceDBUsername`                 | normal_user                           | 监听数据库username，可以只配置只读权限的账号 [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceDBPassword`                 | RadonDB@123                           | 监听数据库password，可以只配置只读权限的账号 [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceConnectionCharset`                 | UTF-8                           | canal.instance.connectionCharset [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceEnableDruid`                 | false                           | canal.instance.enableDruid [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceFilterRegex`                 | .*\\..*                           | canal.instance.filter.regex [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceFilterField`                 | null                           | canal.instance.filter.field [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceFilterBlackRegex`                 | null                           | canal.instance.filter.black.regex [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalInstanceFilterBlackField`                 | null                           | canal.instance.filter.black.field [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqTopic`                 | ddl                           | canal.mq.topic [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqDynamicTopic`                 | .*\\..*                           | canal.mq.dynamicTopic [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqPartition`                 | 0                           | canal.mq.partition [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqPartitionsNum`                 | 3                           | canal.mq.partitionsNum [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqPartitionHash`                 | null                           | canal.mq.partitionHash [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |
| `defaultSampleCanalInstance.canalMqEnableDynamicQueuePartition`                 | true                           | canal.mq.enableDynamicQueuePartition [配置参考](https://github.com/alibaba/canal/blob/master/admin/admin-web/src/main/resources/instance-template.properties)   |


## Access canal admin

username: admin  
password: 123456  

## 已知问题

开启HA 模式 需要手动重启集群，即重新保存主配置，不然 canal server 会不停自动重启 canal admin 并报
```
connect to ip:canal-server-0.canal-server-headless.canal,port:11110,user:admin,password:******, failed
```