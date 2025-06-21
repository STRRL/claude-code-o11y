# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository sets up a complete observability stack for Claude Code using the Grafana ecosystem. It provides comprehensive telemetry collection, metrics storage, log aggregation, and visualization for Claude Code sessions through OpenTelemetry (OTLP) integration.

## Architecture

**Data Flow**: Claude Code → OpenTelemetry Collector → Prometheus (metrics) + Loki (logs) → Grafana (visualization)

- **OpenTelemetry Collector**: Central hub that receives OTLP data from Claude Code and routes to appropriate backends
- **Prometheus**: Time-series metrics database with dedicated scraping for Claude Code metrics
- **Loki**: Log aggregation system for structured log storage and querying  
- **Grafana**: Unified dashboard and visualization platform with data source connections to both Prometheus and Loki

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
docker-compose logs grafana
docker-compose logs prometheus  
docker-compose logs loki
docker-compose logs otel-collector
```

### Restart specific services:
```bash
docker-compose restart grafana
docker-compose restart prometheus
docker-compose restart otel-collector
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

## Configuration Details

### OpenTelemetry Collector Pipeline
- **Receivers**: OTLP gRPC (4317) and HTTP (4318) protocols
- **Processors**: Memory limiting (512MB) and batching (1s timeout, 1024 batch size)
- **Exporters**: Prometheus metrics exporter and Loki logs exporter

### Prometheus Scraping Strategy
- **Claude Code Metrics**: Dedicated scrape job with 5s interval targeting `claude_code_*` metrics
- **OTEL Collector**: General metrics scraping every 10s from collector's metrics endpoint

### Environment Variables (claude-code-env.sh)
- `CLAUDE_CODE_ENABLE_TELEMETRY=1` - Activates Claude Code telemetry
- `OTEL_SERVICE_NAME=claude-code` - Service identification in telemetry data
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317` - OTLP gRPC endpoint
- Development-optimized export intervals: 10s metrics, 5s logs

## Operational Workflow

1. **Initialize**: `docker-compose up -d` starts all services with proper dependencies
2. **Configure**: `source claude-code-env.sh` sets telemetry environment variables  
3. **Execute**: Run any Claude Code commands - telemetry flows automatically
4. **Monitor**: Access Grafana at http://localhost:3000 to create dashboards and view metrics/logs
5. **Debug**: Use Prometheus at http://localhost:9090 for direct metrics queries