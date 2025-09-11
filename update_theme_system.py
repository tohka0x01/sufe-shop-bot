#!/usr/bin/env python3
import os
import re

# List of templates to update
templates = [
    "order_list.html",
    "settings.html",
    "faq_list.html",
    "broadcast_list.html",
    "broadcast_detail.html",
    "templates.html",
    "recharge_cards.html",
    "user_list.html",
    "user_detail.html",
    "product_codes.html"
]

# Update function
def update_template(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if already updated
    if 'data-theme="light"' in content or 'theme.css' in content:
        print(f"✓ {os.path.basename(filepath)} already has theme support")
        return
    
    # 1. Add data-theme to html tag
    content = content.replace('<html>', '<html data-theme="light">')
    
    # 2. Add theme CSS link after viewport meta
    viewport_pattern = r'(<meta name="viewport"[^>]+>)'
    replacement = r'\1\n    <meta name="theme-color" content="#ffffff">\n    <link rel="stylesheet" href="/static/theme.css">'
    content = re.sub(viewport_pattern, replacement, content)
    
    # 3. Update colors to use CSS variables
    replacements = [
        # Background colors
        ('background: #0f0f1e;', 'background: var(--bg-primary);'),
        ('background: #1a1a2e;', 'background: var(--bg-primary);'),
        ('background-color: #0f0f1e;', 'background-color: var(--bg-primary);'),
        
        # Text colors
        ('color: #fff;', 'color: var(--text-primary);'),
        ('color: #ffffff;', 'color: var(--text-primary);'),
        ('color: white;', 'color: var(--text-primary);'),
        
        # Glass backgrounds
        ('rgba(255, 255, 255, 0.1)', 'var(--glass-bg)'),
        ('rgba(255, 255, 255, 0.05)', 'var(--hover-bg)'),
        
        # Borders
        ('rgba(255, 255, 255, 0.2)', 'var(--glass-border)'),
        
        # Shadows
        ('rgba(0, 0, 0, 0.1)', 'var(--shadow-color)'),
        
        # Text opacity variants
        ('rgba(255, 255, 255, 0.9)', 'var(--text-primary)'),
        ('rgba(255, 255, 255, 0.8)', 'var(--text-primary)'),
        ('rgba(255, 255, 255, 0.7)', 'var(--text-secondary)'),
        ('rgba(255, 255, 255, 0.6)', 'var(--text-secondary)'),
        ('rgba(255, 255, 255, 0.5)', 'var(--text-tertiary)'),
        ('rgba(255, 255, 255, 0.4)', 'var(--text-tertiary)'),
        ('rgba(255, 255, 255, 0.3)', 'var(--text-tertiary)'),
    ]
    
    for old, new in replacements:
        content = content.replace(old, new)
    
    # 4. Add theme toggle button to header
    if 'logout-btn' in content and 'theme-toggle' not in content:
        # Find logout button and add theme toggle before it
        logout_pattern = r'(<button class="logout-btn"[^>]+>[^<]+</button>)'
        theme_toggle = '''<button class="theme-toggle" onclick="toggleTheme()" title="切换主题 (Ctrl+Shift+T)">
                    <span class="theme-toggle-icon sun">☀️</span>
                    <span class="theme-toggle-icon moon">🌙</span>
                </button>
                '''
        replacement = f'<div style="display: flex; align-items: center; gap: 16px;">\n                {theme_toggle}\\1\n            </div>'
        content = re.sub(logout_pattern, replacement, content)
    
    # 5. Add theme.js script before closing body
    if 'theme.js' not in content:
        theme_script = '''    <script src="/static/theme.js"></script>
    <script>
        function toggleTheme() {
            if (window.themeManager) {
                window.themeManager.toggleTheme();
            }
        }
    </script>
</body>'''
        content = content.replace('</body>', theme_script)
    
    # Save updated content
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ Updated {os.path.basename(filepath)}")

# Main execution
template_dir = "/data/sufe/shop-bot/templates"

for template in templates:
    filepath = os.path.join(template_dir, template)
    if os.path.exists(filepath):
        update_template(filepath)
    else:
        print(f"❌ File not found: {template}")

print("\n✨ Theme update complete!")