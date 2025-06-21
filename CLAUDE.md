# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository sets up a complete observability stack for Claude Code using Vector and the Grafana ecosystem. It provides comprehensive telemetry collection, metrics storage, log aggregation, and visualization for Claude Code sessions through OpenTelemetry (OTLP) integration.

## Architecture

**Data Flow**: Claude Code → Vector (OTLP receiver) → Prometheus (metrics) + Loki (logs) → Grafana (visualization)

- **Vector**: High-performance observability data pipeline that receives OTLP data from Claude Code and routes to appropriate backends
- **Prometheus**: Time-series metrics database that scrapes Vector's exported metrics
- **Loki**: Log aggregation system for structured log storage and querying  
- **Grafana**: Unified dashboard and visualization platform with pre-configured data sources

## Common Commands

### Start the complete observability stack:
```bash
docker-compose up -d
```

### Configure Claude Code environment for telemetry:
```bash
source claude-code-env.sh
```

### Run Claude Code with telemetry enabled:
```bash
claude
```

### Monitor individual service logs:
```bash
docker-compose logs vector
docker-compose logs grafana
docker-compose logs prometheus  
docker-compose logs loki
```

### Restart specific services:
```bash
docker-compose restart vector
docker-compose restart grafana
docker-compose restart prometheus
```

### Stop all services and cleanup:
```bash
docker-compose down
```

## Service Endpoints

- **Grafana Dashboard**: http://localhost:3000 (admin/admin)
- **Prometheus Metrics**: http://localhost:9090
- **Loki Logs API**: http://localhost:3100
- **OTLP gRPC Receiver**: http://localhost:4317
- **OTLP HTTP Receiver**: http://localhost:4318
- **Vector API**: http://localhost:8686
- **Vector Metrics**: http://localhost:9091 (Claude Code metrics), http://localhost:9092 (Vector internal metrics)

## Configuration Details

### Vector Pipeline (vector.toml)
- **Sources**: OTLP receiver accepting both gRPC (4317) and HTTP (4318) protocols
- **Transforms**: Metric name normalization (dots to underscores for Prometheus compatibility)
- **Sinks**: Prometheus exporter (9091) for Claude Code metrics, Loki sink for logs
- **Internal metrics**: Exported on port 9092 for Vector monitoring

### Key Metrics Available
See METRICS.md for detailed metric specifications including:
- `claude_code_cost_usage` - API usage costs by model and user
- `claude_code_token_usage` - Token consumption (input/output/cache)
- `claude_code_code_edit_tool_decision` - User decisions on code edits
- `claude_code_lines_of_code_count` - Lines added/removed tracking

### Grafana Configuration
- Pre-configured data sources: Prometheus (metrics) and Loki (logs)
- Dashboard provisioning directory: `./provisioning/dashboards/`
- Custom dashboards: `claude-code-dashboard.json`, `vector-monitoring.json`

### Environment Variables (claude-code-env.sh)
- `CLAUDE_CODE_ENABLE_TELEMETRY=1` - Activates Claude Code telemetry
- `OTEL_SERVICE_NAME=claude-code` - Service identification in telemetry data
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317` - OTLP gRPC endpoint
- Development-optimized export intervals: 10s metrics, 5s logs

## Operational Workflow

1. **Initialize**: `docker-compose up -d` starts all services with proper dependencies (Vector depends on Prometheus/Loki)
2. **Configure**: `source claude-code-env.sh` sets telemetry environment variables  
3. **Execute**: Run any Claude Code commands - telemetry flows automatically through Vector pipeline
4. **Monitor**: Access Grafana at http://localhost:3000 to view pre-built dashboards or create custom ones
5. **Debug**: Use Vector API at http://localhost:8686 for pipeline status, Prometheus at http://localhost:9090 for direct metric queries