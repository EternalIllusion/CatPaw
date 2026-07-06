#!/usr/bin/env python3
"""
Generate index.ts from result.css for JetBrainsMapleMono font.
Parses the CSS @font-face rules and generates TypeScript imports and descriptors.
"""

import re
import os
from pathlib import Path

def parse_css(css_content: str) -> list[dict]:
    """Parse CSS @font-face rules and extract unicode-range and src url."""
    font_faces = []
    
    # Match each @font-face block (handles minified CSS)
    pattern = r'@font-face\s*\{([^}]+)\}'
    matches = re.findall(pattern, css_content, re.DOTALL)
    
    for match in matches:
        # Extract unicode-range
        unicode_range_match = re.search(r'unicode-range\s*:\s*([^;]+);', match)
        # Extract src url - handle both local() and url() combinations
        src_match = re.search(r'url\(["\']?\./([^"\')\s]+)["\']?\)', match)
        
        if unicode_range_match and src_match:
            unicode_range = unicode_range_match.group(1).strip()
            filename = src_match.group(1).strip()
            
            font_faces.append({
                'filename': filename,
                'unicode_range': unicode_range
            })
    
    return font_faces

def generate_ts(font_faces: list[dict], output_path: str):
    """Generate TypeScript index.ts file."""
    lines = []
    
    # Header
    lines.append('import { type ExcalidrawFontFaceDescriptor } from "../Fonts";')
    lines.append('')
    
    # Generate imports with numbered variables
    for i, font_face in enumerate(font_faces):
        filename = font_face['filename']
        # Remove extension for import
        name_without_ext = os.path.splitext(filename)[0]
        lines.append(f'import _{i} from "./{filename}";')
    
    lines.append('')
    lines.append('/*')
    lines.append('JetBrains Maple Mono Font')
    lines.append('Copyright 2020 The JetBrains Mono Project Authors')
    lines.append('Copyright 2022 The Maple Mono Project Authors')
    lines.append('Copyright 2025 Space Time (Fusion-JetBrainsMapleMono)')
    lines.append('Licensed under SIL Open Font License 1.1')
    lines.append('*/')
    lines.append('')
    
    # Generate font faces array
    lines.append('export const JetBrainsMapleMonoFontFaces: ExcalidrawFontFaceDescriptor[] = [')
    
    for i, font_face in enumerate(font_faces):
        unicode_range = font_face['unicode_range']
        lines.append('  {')
        lines.append(f'    uri: _{i},')
        lines.append('    descriptors: {')
        lines.append(f'      unicodeRange: "{unicode_range}",')
        lines.append('    },')
        lines.append('  },')
    
    lines.append('];')
    lines.append('')
    
    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"Generated {output_path} with {len(font_faces)} font faces")

def main():
    script_dir = Path(__file__).parent
    css_path = script_dir / 'result.css'
    output_path = script_dir / 'index.ts'
    
    # Read CSS file
    with open(css_path, 'r', encoding='utf-8') as f:
        css_content = f.read()
    
    # Parse CSS
    font_faces = parse_css(css_content)
    
    if not font_faces:
        print("Error: No @font-face rules found in result.css")
        return
    
    print(f"Found {len(font_faces)} @font-face rules")
    
    # Generate TypeScript
    generate_ts(font_faces, str(output_path))

if __name__ == '__main__':
    main()
