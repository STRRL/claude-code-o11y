# Claude Code + HyperDX 监控集成

## 快速启动

### 1. 启动 HyperDX
```bash
docker-compose up -d
```

### 2. 设置 Claude Code 环境变量
```bash
source claude-code-env.sh
```

### 3. 启动 Claude Code
```bash
claude
```

### 4. 访问 HyperDX 控制台
打开浏览器访问: http://localhost:8080

## 关键端点
- **Web UI**: http://localhost:8080
- **OTLP gRPC**: http://localhost:4317  
- **OTLP HTTP**: http://localhost:4318

## 验证连接
1. 运行几个 claude 命令
2. 在 HyperDX UI 中查看 metrics 和 logs
3. 服务名显示为 `claude-code`

## 故障排除
```bash
# 查看 HyperDX 容器状态
docker-compose logs hyperdx

# 重启服务
docker-compose restart hyperdx
```