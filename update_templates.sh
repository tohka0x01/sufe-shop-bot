#!/bin/bash
# Script to update all templates to use the theme system

# Create a backup directory
mkdir -p templates/backup

# Function to update a template file
update_template() {
    local file=$1
    local title=$2
    local nav_active=$3
    
    echo "Updating $file..."
    
    # Backup original file
    cp "templates/$file" "templates/backup/$file.bak"
    
    # Create new file with theme support
    cat > "templates/$file" << 'EOF'
<!DOCTYPE html>
<html data-theme="light">
<head>
    <title>TEMPLATE_TITLE</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#ffffff">
    <link rel="stylesheet" href="/static/theme.css">
    <style>
        /* Base styles */
        * { 
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Helvetica Neue", Helvetica, Arial, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
            transition: var(--theme-transition);
        }
        
        /* Aurora Background Animation */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 50%, rgba(102, 126, 234, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(255, 154, 139, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 70% 30%, rgba(255, 206, 84, 0.2) 0%, transparent 50%);
            animation: aurora 20s ease-in-out infinite;
            z-index: -1;
            opacity: 0.8;
        }
        
        [data-theme="light"] body::before {
            opacity: 0.5;
        }
        
        @keyframes aurora {
            0%, 100% { transform: rotate(0deg) scale(1); }
            25% { transform: rotate(5deg) scale(1.1); }
            50% { transform: rotate(-5deg) scale(1); }
            75% { transform: rotate(3deg) scale(1.05); }
        }
        
        /* Header */
        .header {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--glass-border);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 8px 32px var(--shadow-color);
            transition: var(--theme-transition);
        }
        
        .header::before {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--aurora-gradient);
            opacity: 0.5;
            animation: shimmer 3s ease-in-out infinite;
        }
        
        @keyframes shimmer {
            0%, 100% { opacity: 0.5; }
            50% { opacity: 0.8; }
        }
        
        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 70px;
            position: relative;
            z-index: 1;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.5px;
        }
        
        .logout-btn {
            padding: 10px 24px;
            background: var(--danger-gradient);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(245, 87, 108, 0.3);
        }
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
        }
        
        .container { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 24px;
        }
        
        /* Navigation */
        .nav { 
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 8px;
            margin-bottom: 24px;
            box-shadow: 0 8px 32px var(--shadow-color);
            display: flex;
            gap: 8px;
            overflow-x: auto;
            scrollbar-width: none;
            transition: var(--theme-transition);
        }
        
        .nav::-webkit-scrollbar {
            display: none;
        }
        
        .nav a { 
            flex: 0 0 auto;
            padding: 12px 24px;
            color: var(--text-secondary);
            text-decoration: none;
            text-align: center;
            border-radius: 12px;
            transition: all 0.3s ease;
            font-weight: 500;
            white-space: nowrap;
        }
        
        .nav a:hover { 
            background: var(--hover-bg);
            color: var(--text-primary);
        }
        
        .nav a.active {
            background: var(--primary-gradient);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        /* Glass Cards */
        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 8px 32px var(--shadow-color);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
            transition: var(--theme-transition);
        }
        
        .glass-card::before {
            content: '';
            position: absolute;
            inset: 0;
            background: var(--aurora-gradient);
            opacity: 0.3;
            animation: shimmer 4s ease-in-out infinite;
        }
        
        .glass-card > * {
            position: relative;
            z-index: 1;
        }
        
        /* Page Title */
        .page-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 32px;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* Buttons */
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary {
            background: var(--primary-gradient);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-default {
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            color: var(--text-primary);
        }
        
        .btn-default:hover {
            background: var(--hover-bg);
        }
        
        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            overflow: hidden;
        }
        
        th {
            background: var(--hover-bg);
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 1px solid var(--border-color);
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-secondary);
        }
        
        tr:hover {
            background: var(--hover-bg);
        }
        
        /* Form elements */
        input[type="text"],
        input[type="number"],
        input[type="date"],
        input[type="email"],
        input[type="password"],
        select,
        textarea {
            width: 100%;
            padding: 12px 16px;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-primary);
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 16px;
            }
            
            .page-title {
                font-size: 24px;
            }
            
            .nav {
                padding: 4px;
            }
            
            .nav a {
                padding: 8px 16px;
                font-size: 14px;
            }
        }
    </style>
    <!-- Page specific styles -->
    <style>
        /* Add page-specific styles here */
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">商城机器人管理中心</div>
            <div style="display: flex; align-items: center;">
                <div class="theme-toggle" title="切换主题 (Ctrl+Shift+T)">
                    <span class="theme-toggle-icon sun">☀️</span>
                    <span class="theme-toggle-icon moon">🌙</span>
                </div>
                <button class="logout-btn" onclick="logout()">退出登录</button>
            </div>
        </div>
    </div>
    
    <div class="container">
        <nav class="nav">
            <a href="/admin/" NAV_DASHBOARD>仪表盘</a>
            <a href="/admin/products" NAV_PRODUCTS>商品管理</a>
            <a href="/admin/orders" NAV_ORDERS>订单管理</a>
            <a href="/admin/users" NAV_USERS>用户管理</a>
            <a href="/admin/groups" NAV_GROUPS>群组管理</a>
            <a href="/admin/recharge-cards" NAV_RECHARGE>充值卡管理</a>
            <a href="/admin/broadcast" NAV_BROADCAST>广播消息</a>
            <a href="/admin/templates" NAV_TEMPLATES>消息模板</a>
            <a href="/admin/faq" NAV_FAQ>FAQ管理</a>
            <a href="/admin/settings" NAV_SETTINGS>系统设置</a>
        </nav>
        
        <!-- Page content goes here -->
        TEMPLATE_CONTENT
    </div>
    
    <script src="/static/theme.js"></script>
    <script>
        function logout() {
            fetch('/api/logout', { method: 'POST' })
                .then(() => window.location.href = '/')
                .catch(err => console.error('Logout failed:', err));
        }
        
        // Add dynamic light effect on mouse move
        document.addEventListener('mousemove', (e) => {
            const x = e.clientX / window.innerWidth;
            const y = e.clientY / window.innerHeight;
            
            document.body.style.setProperty('--mouse-x', x);
            document.body.style.setProperty('--mouse-y', y);
        });
    </script>
    <!-- Page specific scripts -->
    <script>
        // Add page-specific scripts here
    </script>
</body>
</html>
EOF
    
    # Replace placeholders
    sed -i "s|TEMPLATE_TITLE|$title|g" "templates/$file"
    
    # Set active navigation
    case $nav_active in
        "dashboard") sed -i "s|NAV_DASHBOARD|class=\"active\"|g" "templates/$file" ;;
        "products") sed -i "s|NAV_PRODUCTS|class=\"active\"|g" "templates/$file" ;;
        "orders") sed -i "s|NAV_ORDERS|class=\"active\"|g" "templates/$file" ;;
        "users") sed -i "s|NAV_USERS|class=\"active\"|g" "templates/$file" ;;
        "groups") sed -i "s|NAV_GROUPS|class=\"active\"|g" "templates/$file" ;;
        "recharge") sed -i "s|NAV_RECHARGE|class=\"active\"|g" "templates/$file" ;;
        "broadcast") sed -i "s|NAV_BROADCAST|class=\"active\"|g" "templates/$file" ;;
        "templates") sed -i "s|NAV_TEMPLATES|class=\"active\"|g" "templates/$file" ;;
        "faq") sed -i "s|NAV_FAQ|class=\"active\"|g" "templates/$file" ;;
        "settings") sed -i "s|NAV_SETTINGS|class=\"active\"|g" "templates/$file" ;;
    esac
    
    # Remove unused NAV_ placeholders
    sed -i "s|NAV_[A-Z]*||g" "templates/$file"
}

# Example: Update product list template
# update_template "product_list.html" "商品管理 - 商城机器人管理中心" "products"

echo "Template update script created. Use update_template function to update each template."