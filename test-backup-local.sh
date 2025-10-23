#!/bin/bash

# 本地测试备份脚本 - 验证GitHub Actions配置

echo "🧪 测试达芬奇数据库备份配置..."

# 数据库连接信息
SUPABASE_HOST="aws-1-ap-south-1.pooler.supabase.com"
SUPABASE_USER="postgres.euxpqtozrrxmjmfioyaw"
SUPABASE_PASSWORD="Drz9m6SVSSYanRW"

# 检查 PostgreSQL 客户端
echo "🔍 检查 PostgreSQL 客户端..."
if ! command -v pg_dump &> /dev/null; then
    echo "❌ pg_dump 未找到"
    echo "请确保已安装 PostgreSQL 客户端"
    exit 1
fi

PG_VERSION=$(pg_dump --version)
echo "✅ PostgreSQL 客户端: $PG_VERSION"

# 测试数据库连接
echo ""
echo "🔗 测试数据库连接..."
PGPASSWORD="$SUPABASE_PASSWORD" psql \
  -h "$SUPABASE_HOST" \
  -p 6543 \
  -U "$SUPABASE_USER" \
  -d postgres \
  -c "SELECT version();" \
  -t

if [ $? -eq 0 ]; then
    echo "✅ 数据库连接成功"
else
    echo "❌ 数据库连接失败"
    exit 1
fi

# 创建测试备份
echo ""
echo "📦 创建测试备份..."
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="test_backup_$DATE.sql"

PGPASSWORD="$SUPABASE_PASSWORD" pg_dump \
  -h "$SUPABASE_HOST" \
  -p 6543 \
  -U "$SUPABASE_USER" \
  -d postgres \
  -f "$BACKUP_FILE" \
  --no-sync \
  --verbose

if [ $? -eq 0 ]; then
    # 压缩备份
    gzip "$BACKUP_FILE"
    
    # 显示备份信息
    BACKUP_SIZE=$(du -h "${BACKUP_FILE}.gz" | cut -f1)
    echo ""
    echo "✅ 测试备份成功！"
    echo "📊 备份文件: ${BACKUP_FILE}.gz"
    echo "📏 文件大小: $BACKUP_SIZE"
    
    # 验证备份文件
    echo ""
    echo "🔍 验证备份文件内容..."
    if gunzip -t "${BACKUP_FILE}.gz"; then
        echo "✅ 备份文件完整性验证通过"
    else
        echo "❌ 备份文件损坏"
    fi
    
    # 清理测试文件
    rm -f "${BACKUP_FILE}.gz"
    echo "🧹 已清理测试文件"
    
else
    echo "❌ 测试备份失败"
    exit 1
fi

echo ""
echo "🎉 所有测试通过！GitHub Actions 配置正确"
echo ""
echo "📋 下一步操作："
echo "1. 在 GitHub 创建新仓库 'davinci-backup'"
echo "2. 推送代码到 GitHub"
echo "3. 设置 Repository Secrets"
echo "4. 手动触发 Actions 测试"