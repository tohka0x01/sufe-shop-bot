#!/usr/bin/env python3
import os
import re

# List of files to fix
files = [
    "/data/sufe/shop-bot/templates/order_list.html",
    "/data/sufe/shop-bot/templates/broadcast_detail.html",
    "/data/sufe/shop-bot/templates/user_detail.html",
    "/data/sufe/shop-bot/templates/user_list.html",
    "/data/sufe/shop-bot/templates/templates.html",
    "/data/sufe/shop-bot/templates/product_codes.html",
    "/data/sufe/shop-bot/templates/recharge_cards.html",
    "/data/sufe/shop-bot/templates/settings.html",
    "/data/sufe/shop-bot/templates/faq_list.html",
    "/data/sufe/shop-bot/templates/broadcast_list.html"
]

def fix_css_variables(filepath):
    """Fix self-referencing CSS variables"""
    if not os.path.exists(filepath):
        print(f"❌ File not found: {filepath}")
        return
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if file has the problem
    if '--glass-bg: var(--glass-bg)' not in content:
        print(f"✓ {os.path.basename(filepath)} is already correct")
        return
    
    # Remove the self-referencing CSS variable definitions in :root
    # Find the :root block
    root_pattern = r':root\s*\{[^}]*\}'
    root_match = re.search(root_pattern, content, re.DOTALL)
    
    if root_match:
        root_content = root_match.group(0)
        # Remove the problematic lines
        lines_to_remove = [
            r'^\s*--glass-bg:\s*var\(--glass-bg\);?\s*$',
            r'^\s*--glass-border:\s*var\(--glass-border\);?\s*$',
            r'^\s*--shadow-color:\s*var\(--shadow-color\);?\s*$',
            r'^\s*--hover-bg:\s*var\(--hover-bg\);?\s*$'
        ]
        
        root_lines = root_content.split('\n')
        filtered_lines = []
        for line in root_lines:
            should_keep = True
            for pattern in lines_to_remove:
                if re.match(pattern, line):
                    should_keep = False
                    break
            if should_keep:
                filtered_lines.append(line)
        
        new_root_content = '\n'.join(filtered_lines)
        content = content.replace(root_content, new_root_content)
    
    # Fix incorrect color variable replacements
    # Fix buttons that should be white
    content = re.sub(
        r'(\.logout-btn[^{]*\{[^}]*color:\s*)var\(--text-primary\)',
        r'\1white',
        content
    )
    content = re.sub(
        r'(\.btn[^{]*\{[^}]*color:\s*)var\(--text-primary\)',
        r'\1white',
        content
    )
    content = re.sub(
        r'(\.nav\s+a\.active[^{]*\{[^}]*color:\s*)var\(--text-primary\)',
        r'\1white',
        content
    )
    
    # Fix bg-primary in select options
    content = re.sub(
        r'(select\s+option[^{]*\{[^}]*background:\s*)var\(--bg-primary\)',
        r'\1#1a1a2e',
        content
    )
    
    # Save the fixed content
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ Fixed {os.path.basename(filepath)}")

# Fix all files
print("Fixing CSS variable issues...\n")
for filepath in files:
    fix_css_variables(filepath)

print("\n✨ CSS fix complete!")