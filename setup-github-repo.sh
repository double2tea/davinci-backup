#!/bin/bash

# GitHub 仓库设置脚本

echo "🚀 设置 GitHub 仓库和 Secrets..."

# 检查是否在正确的目录
if [ ! -f ".github/workflows/backup.yml" ]; then
    echo "❌ 请在 davinci-backup 目录中运行此脚本"
    exit 1
fi

echo ""
echo "📋 请按照以下步骤操作："
echo ""

# 步骤1：创建GitHub仓库
echo "1️⃣ 创建 GitHub 仓库："
echo "   - 访问 https://github.com/new"
echo "   - Repository name: davinci-backup"
echo "   - 设为 Public（免费版需要公开仓库才能使用Actions）"
echo "   - 不要初始化 README、.gitignore 或 license"
echo "   - 点击 'Create repository'"
echo ""

# 获取用户名
echo "2️⃣ 输入你的 GitHub 用户名："
read -p "GitHub 用户名: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

# 设置远程仓库
REPO_URL="https://github.com/$GITHUB_USERNAME/davinci-backup.git"
echo ""
echo "3️⃣ 设置远程仓库..."

# 检查是否已经有远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    echo "更新远程仓库地址..."
    git remote set-url origin "$REPO_URL"
else
    echo "添加远程仓库..."
    git remote add origin "$REPO_URL"
fi

# 推送代码
echo ""
echo "4️⃣ 推送代码到 GitHub..."
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ 代码推送成功！"
else
    echo "❌ 推送失败，请检查："
    echo "   - GitHub 用户名是否正确"
    echo "   - 是否已创建仓库"
    echo "   - 是否有推送权限"
    exit 1
fi

# 设置 Secrets 指导
echo ""
echo "5️⃣ 设置 Repository Secrets："
echo "   访问: https://github.com/$GITHUB_USERNAME/davinci-backup/settings/secrets/actions"
echo ""
echo "   点击 'New repository secret' 添加以下 3 个 Secrets："
echo ""
echo "   Secret 1:"
echo "   Name: SUPABASE_HOST"
echo "   Value: aws-1-ap-south-1.pooler.supabase.com"
echo ""
echo "   Secret 2:"
echo "   Name: SUPABASE_USER"
echo "   Value: postgres.euxpqtozrrxmjmfioyaw"
echo ""
echo "   Secret 3:"
echo "   Name: SUPABASE_PASSWORD"
echo "   Value: Drz9m6SVSSYanRW"
echo ""

# 启用 Actions 指导
echo "6️⃣ 启用 GitHub Actions："
echo "   访问: https://github.com/$GITHUB_USERNAME/davinci-backup/actions"
echo "   点击 'I understand my workflows, go ahead and enable them'"
echo ""

# 手动触发测试
echo "7️⃣ 测试备份："
echo "   在 Actions 页面，点击 'DaVinci Database Backup'"
echo "   点击 'Run workflow' → 'Run workflow' 手动触发测试"
echo ""

echo "🎉 设置完成！"
echo ""
echo "📊 备份计划："
echo "   - 每天北京时间上午 10 点自动备份"
echo "   - 备份文件保存在 Releases 页面"
echo "   - 自动保留最近 30 天的备份"
echo ""
echo "🔗 重要链接："
echo "   仓库地址: https://github.com/$GITHUB_USERNAME/davinci-backup"
echo "   Actions: https://github.com/$GITHUB_USERNAME/davinci-backup/actions"
echo "   Releases: https://github.com/$GITHUB_USERNAME/davinci-backup/releases"