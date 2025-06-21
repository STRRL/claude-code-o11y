#!/bin/bash
# Grafana Stack + Claude Code 集成环境变量

# 1. 启用 Claude Code 遥测
export CLAUDE_CODE_ENABLE_TELEMETRY=1

# 2. 配置 OTLP 导出器
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp

# 3. OpenTelemetry Collector OTLP 端点配置
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# 4. 服务标识（可选，方便区分）
export OTEL_SERVICE_NAME=claude-code
export OTEL_SERVICE_VERSION=1.0.0

# 5. 调试用：减少导出间隔
export OTEL_METRIC_EXPORT_INTERVAL=10000  # 10秒
export OTEL_LOGS_EXPORT_INTERVAL=5000     # 5秒

echo "Grafana Stack 环境变量已设置，可以启动 claude 了！"
echo "访问地址："
echo "  - Grafana: http://localhost:3000 (admin/admin)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Loki: http://localhost:3100"