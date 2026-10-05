# mysql-monitoring-perf-lab
MySQL监控与性能优化实验环境 (Prometheus + Grafana + Sysbench)
##目录结构
```
mysql-monitoring-perf-lab/
├── README.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── conf/
│   ├── prometheus.yml
│   ├── grafana-datasource.yml
│   └── mysqld_exporter.cnf.example
├── sql/
│   ├── 01_schema.sql  #建库、建表，定义用户、商品、订单等表结构
│   ├── 02_seed_users_products.sql  #插入初始用户、商品等基础数据
│   ├── 03_generate_orders_proc.sq、03_generate_users_proc.sql、03_generate_products_proc.sql  #创建存储过程，用于批量生成订单数据
│   └── 04_index_optimization.sql3  #优化脚本，添加索引、修改查询、调整表结构等
├── scripts/
│   ├── start.sh  #一键启动实验环境，可能执行 docker compose up -d、等待 MySQL 就绪等
│   ├── gen_data.sh  #生成测试数据，可能调用 03_generate_orders_proc.sql
│   ├── run_sysbench.sh  #运行 sysbench OLTP 读写压测，如 oltp_read_write
│   ├── collect_metrics.sh  #收集 MySQL 状态指标，如 SHOW GLOBAL STATUS、慢查询、连接数等
│   └── collect_explain.sh  #收集 SQL 执行计划，通常用 EXPLAIN FORMAT=JSON
├── bench/
│   ├── baseline/
│   │   ├── sysbench_oltp_read_write.log  #sysbench 压测日志，记录 TPS、QPS、延迟等
│   │   ├── mysql_status_before.txt  #MySQL 状态变量快照
│   │   ├── explain_before.json  #SQL 执行计划对比
│   │   └── slow_query_before.log  #慢查询日志对比
│   └── after/
│       ├── sysbench_oltp_read_write.log
│       ├── mysql_status_after.txt
│       ├── explain_after.json
│       └── slow_query_after.log
├── dashboards/
│   └── mysql-overview-14057.json  #Grafana 官方 MySQL Overview 仪表盘QPS、连接数、InnoDB 缓冲池、慢查询、锁等待、网络流量、线程状态
├── docs/
│   ├── 01-baseline.md  #记录优化前基线：环境、数据量、压测命令、指标结果
│   ├── 02-optimization.md  #记录做了哪些优化，如加索引、改 SQL、调参数
│   ├── 03-comparison.md  #对比优化前后 TPS、QPS、延迟、慢查询、EXPLAIN
│   └── 04-troubleshooting-sop.md  #故障排查标准作业流程，如 MySQL 连不上、Exporter 无指标、Grafana 无数据等
└── screenshots/
    ├── grafana-before.png  #优化前 Grafana 监控截图
    └── grafana-after.pngjeis  #优化后 Grafana 监控截图
```
