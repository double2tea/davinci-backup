#!/bin/bash

# GitHub 仓库设置脚本

echo "🚀 设置 GitHub 仓库和 Actions..."

# 检查是否安装了 GitHub CLI
if command -v gh &> /dev/null; then
    echo "✅ 检测到 GitHub CLI"
    
    # 检查是否已登录
    if gh auth status &> /dev/null; then
        echo "✅ GitHub CLI 已登录"
        
        # 创建仓库
        echo "📦 创建 GitHub 仓库..."
        gh repo create davinci-backup --public --description "达芬奇数据库云端自动备份系统" --clone=false
        
        if [ $? -eq 0 ]; then
            echo "✅ GitHub 仓库创建成功"
            
            # 获取用户名
            USERNAME=$(gh api user --jq .login)
            
            # 添加远程仓库
            git remote add origin https://github.com/$USERNAME/davinci-backup.git
            
            # 推送代码
            echo "📤 推送代码到 GitHub..."
            git push -u origin main
            
            if [ $? -eq 0 ]; then
                echo "✅ 代码推送成功"
                
                # 设置 Secrets
                echo "🔐 设置 Repository Secrets..."
                gh secret set SUPABASE_HOST --body "aws-1-ap-south-1.pooler.supabase.com"
                gh secret set SUPABASE_USER --body "postgres.euxpqtozrrxmjmfioyaw"
                gh secret set SUPABASE_PASSWORD --body "Drz9m6SVSSYanRW"
                
                echo "✅ Secrets 设置完成"
                
                # 手动触发 Actions
                echo "🎯 手动触发备份测试..."
                gh workflow run backup.yml
                
                echo ""
                echo "🎉 GitHub Actions 云端备份设置完成！"
                echo ""
                echo "📋 查看状态："
                echo "🌐 仓库地址: https://github.com/$USERNAME/davinci-backup"
                echo "⚡ Actions: https://github.com/$USERNAME/davinci-backup/actions"
                echo "📦 Releases: https://github.com/$USERNAME/davinci-backup/releases"
                echo ""
                echo "⏰ 备份计划: 每天北京时间上午10点自动执行"
                echo "🔧 手动触发: gh workflow run backup.yml"
                
            else
                echo "❌ 代码推送失败"
            fi
        else
            echo "❌ GitHub 仓库创建失败"
        fi
    else
        echo "❌ GitHub CLI 未登录"
        echo "请运行: gh auth login"
    fi
else
    echo "⚠️  未检测到 GitHub CLI"
    echo ""
    echo "📋 手动设置步骤："
    echo "1. 访问 https://github.com/new"
    echo "2. 仓库名: davinci-backup"
    echo "3. 设为 Public"
    echo "4. 创建仓库"
    echo ""
    echo "5. 推送代码:"
    echo "   git remote add origin https://github.com/你的用户名/davinci-backup.git"
    echo "   git push -u origin main"
    echo ""
    echo "6. 设置 Secrets (Settings → Secrets and variables → Actions):"
    echo "   - SUPABASE_HOST: aws-1-ap-south-1.pooler.supabase.com"
    echo "   - SUPABASE_USER: postgres.euxpqtozrrxmjmfioyaw"
    echo "   - SUPABASE_PASSWORD: Drz9m6SVSSYanRW"
    echo ""
    echo "7. 启用 Actions 并手动触发测试"
fi