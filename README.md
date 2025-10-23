# 达芬奇数据库云端备份

🌐 使用 GitHub Actions 实现完全免费的云端自动备份

## 功能特点

- ⏰ 每日自动备份（北京时间上午10点）
- 🌐 完全云端运行，无需本地设备
- 💰 完全免费
- 📱 所有设备都能访问备份
- 🗂️ 自动保留最近30天的备份

## 备份文件

备份文件存储在 [Releases](../../releases) 页面，包含：
- 完整的数据库结构
- 所有项目数据
- 用户设置和配置

## 恢复方法

1. 从 Releases 下载备份文件
2. 解压缩：`gunzip davinci_backup_*.sql.gz`
3. 恢复到数据库：`psql -h host -U user -d postgres < backup.sql`

## 手动触发备份

在 [Actions](../../actions) 页面可以手动触发备份任务。
