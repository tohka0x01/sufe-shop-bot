#!/bin/bash

# Script to update all HTML templates with theme support

templates=(
    "product_list.html"
    "dashboard.html"
    "order_list.html"
    "settings.html"
    "faq_list.html"
    "broadcast_list.html"
    "broadcast_detail.html"
    "templates.html"
    "recharge_cards.html"
    "user_list.html"
    "user_detail.html"
    "product_codes.html"
)

for template in "${templates[@]}"; do
    file="/data/sufe/shop-bot/templates/$template"
    if [ -f "$file" ]; then
        echo "Updating $template..."
        
        # Add data-theme attribute to html tag
        sed -i 's/<html>/<html data-theme="light">/' "$file"
        
        # Add theme CSS link after viewport meta tag
        sed -i '/<meta name="viewport"/a\    <meta name="theme-color" content="#ffffff">\n    <link rel="stylesheet" href="/static/theme.css">' "$file"
        
        # Update body background color
        sed -i 's/background: #0f0f1e;/background: var(--bg-primary);/' "$file"
        sed -i 's/color: #fff;/color: var(--text-primary);/' "$file"
        
        # Update glass backgrounds
        sed -i 's/rgba(255, 255, 255, 0.1)/var(--glass-bg)/g' "$file"
        sed -i 's/rgba(255, 255, 255, 0.2)/var(--glass-border)/g' "$file"
        sed -i 's/rgba(0, 0, 0, 0.1)/var(--shadow-color)/g' "$file"
        
        # Update text colors
        sed -i 's/rgba(255, 255, 255, 0.9)/var(--text-primary)/g' "$file"
        sed -i 's/rgba(255, 255, 255, 0.8)/var(--text-primary)/g' "$file"
        sed -i 's/rgba(255, 255, 255, 0.7)/var(--text-secondary)/g' "$file"
        sed -i 's/rgba(255, 255, 255, 0.6)/var(--text-secondary)/g' "$file"
        sed -i 's/rgba(255, 255, 255, 0.5)/var(--text-tertiary)/g' "$file"
        
        # Add theme toggle to header
        if grep -q "logout-btn" "$file" && ! grep -q "theme-toggle" "$file"; then
            # Add theme toggle button after logo
            sed -i '/<div class="logo">/a\            <button class="theme-toggle" onclick="toggleTheme()" title="切换主题 (Ctrl+Shift+T)">\n                <span class="theme-toggle-icon sun">☀️</span>\n                <span class="theme-toggle-icon moon">🌙</span>\n            </button>' "$file"
        fi
        
        # Add theme.js script before closing body tag
        if ! grep -q "theme.js" "$file"; then
            sed -i '/<\/body>/i\    <script src="/static/theme.js"></script>\n    <script>\n        function toggleTheme() {\n            if (window.themeManager) {\n                window.themeManager.toggleTheme();\n            }\n        }\n    </script>' "$file"
        fi
        
        echo "✓ Updated $template"
    else
        echo "✗ File not found: $template"
    fi
done

echo "Theme update complete!"