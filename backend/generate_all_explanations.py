"""
Script to pre-generate AI explanations for ALL sections.
Run this ONCE to generate explanations that will be bundled with the app.
This eliminates the need for live API calls for section explanations.

Usage:
    python generate_all_explanations.py
    
Output:
    - mobile/assets/ai_explanations/bns_explanations_en.json
    - mobile/assets/ai_explanations/bns_explanations_hi.json
    - mobile/assets/ai_explanations/bnss_explanations_en.json
    - mobile/assets/ai_explanations/bnss_explanations_hi.json
    - mobile/assets/ai_explanations/bsa_explanations_en.json
    - mobile/assets/ai_explanations/bsa_explanations_hi.json
"""

import json
import time
from pathlib import Path
from typing import Dict, List
import sys
import os

# Add parent directory to path to import ai_service
sys.path.insert(0, str(Path(__file__).parent))

from app.ai_service import legal_ai

# Paths
DATA_DIR = Path(__file__).parent / "data" / "structured"
OUTPUT_DIR = Path(__file__).parent.parent / "mobile" / "assets" / "ai_explanations"

# Create output directory
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Acts to process
ACTS = {
    "BNS-2023": "bns_en.json",
    "BNSS-2023": "bnss_en.json", 
    "BSA-2023": "bsa_en.json"
}

def load_sections(act_file: str) -> List[Dict]:
    """Load sections from structured JSON file."""
    file_path = DATA_DIR / act_file
    
    if not file_path.exists():
        print(f"❌ File not found: {file_path}")
        return []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    sections = data.get('sections', [])
    print(f"✅ Loaded {len(sections)} sections from {act_file}")
    return sections


def generate_explanations_for_act(act_id: str, act_file: str, language: str = "en"):
    """Generate AI explanations for all sections of an act."""
    
    print(f"\n{'='*60}")
    print(f"📝 Generating {language.upper()} explanations for {act_id}")
    print(f"{'='*60}\n")
    
    sections = load_sections(act_file)
    
    if not sections:
        print(f"⚠️  No sections found for {act_id}")
        return
    
    # Filter sections that have content
    sections_with_content = [s for s in sections if s.get('text_en') and s['text_en'].strip()]
    print(f"📊 Sections with content: {len(sections_with_content)} / {len(sections)}")
    
    explanations = {}
    total = len(sections_with_content)
    
    for idx, section in enumerate(sections_with_content, 1):
        section_num = section.get('number', f"section_{idx}")
        section_text = section.get('text_en', '')
        
        if not section_text or len(section_text.strip()) < 10:
            continue
        
        print(f"[{idx}/{total}] Generating explanation for Section {section_num}...", end='')
        
        try:
            # Generate explanation
            result = legal_ai.explain_section(
                section_text=section_text,
                language=language,
                include_examples=True
            )
            
            explanations[section_num] = {
                "section_number": section_num,
                "heading": section.get('heading', ''),
                "simple_explanation": result.get('simple_explanation', ''),
                "examples": result.get('examples', ''),
                "generated_at": time.strftime("%Y-%m-%d %H:%M:%S")
            }
            
            print(f" ✅ Done")
            
            # Rate limiting: Wait 4 seconds between requests (15 req/min limit)
            if idx < total:
                time.sleep(4)
                
        except Exception as e:
            print(f" ❌ Error: {e}")
            explanations[section_num] = {
                "section_number": section_num,
                "heading": section.get('heading', ''),
                "simple_explanation": "Explanation not available.",
                "examples": "",
                "error": str(e)
            }
    
    # Save to JSON
    output_file = OUTPUT_DIR / f"{act_id.lower().replace('-', '_')}_explanations_{language}.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump({
            "act_id": act_id,
            "language": language,
            "total_sections": len(explanations),
            "generated_at": time.strftime("%Y-%m-%d %H:%M:%S"),
            "explanations": explanations
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Saved {len(explanations)} explanations to: {output_file}")
    print(f"📦 File size: {output_file.stat().st_size / 1024:.2f} KB")


def main():
    """Generate explanations for all acts in both languages."""
    
    print("\n" + "="*60)
    print("🚀 PRE-GENERATING ALL AI EXPLANATIONS")
    print("="*60)
    print("\nThis will generate AI explanations for ALL sections.")
    print("Estimated time: 1-2 hours (rate limited to 15 req/min)")
    print("\nLanguages: English (en) and Hindi (hi)")
    print(f"Output directory: {OUTPUT_DIR}")
    
    input("\nPress Enter to start generation... (Ctrl+C to cancel)")
    
    start_time = time.time()
    
    # Generate for each act and language
    for act_id, act_file in ACTS.items():
        # English explanations
        generate_explanations_for_act(act_id, act_file, language="en")
        
        print("\n⏳ Waiting 10 seconds before next act...")
        time.sleep(10)
        
        # Hindi explanations
        generate_explanations_for_act(act_id, act_file, language="hi")
        
        print("\n⏳ Waiting 10 seconds before next act...")
        time.sleep(10)
    
    elapsed = time.time() - start_time
    print("\n" + "="*60)
    print("✅ ALL EXPLANATIONS GENERATED SUCCESSFULLY!")
    print("="*60)
    print(f"⏱️  Total time: {elapsed/60:.1f} minutes")
    print(f"📁 Output location: {OUTPUT_DIR}")
    print("\nNext steps:")
    print("1. Add these files to mobile/pubspec.yaml under assets")
    print("2. Update Flutter app to load from assets instead of API")
    print("3. Remove AI explanation API calls from mobile app")
    print("4. Build new app version with bundled explanations")


if __name__ == "__main__":
    main()
