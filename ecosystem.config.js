{
  "apps": [
    {
      "name": "will-dtf",
      "script": ".next/server.js",
      "instances": "max",
      "exec_mode": "cluster",
      "env": {
        "NODE_ENV": "production",
        "PORT": 3000,
        "NEXT_TELEMETRY_DISABLED": "1"
      },
      "error_file": "./logs/error.log",
      "out_file": "./logs/out.log",
      "log_date_format": "YYYY-MM-DD HH:mm:ss Z",
      "merge_logs": true,
      "max_memory_restart": "500M",
      "watch": false,
      "ignore_watch": [
        "node_modules",
        "logs",
        ".next"
      ],
      "max_restarts": 10,
      "min_uptime": "10s",
      "autorestart": true
    }
  ]
}
