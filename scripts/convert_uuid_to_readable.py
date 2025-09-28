#!/usr/bin/env python3
"""
Script to convert UUID-based seed data to readable code format
Usage: python convert_uuid_to_readable.py input_file.sql output_file.sql
"""

import re
import sys
import json
from pathlib import Path

# Mapping of UUID patterns to readable codes
UUID_MAPPINGS = {
    # World Regions
    '11111111-1111-1111-1111-111111111001': 'cobblestone',
    '11111111-1111-1111-1111-111111111002': 'heliodor_region',
    '11111111-1111-1111-1111-111111111008': 'dark_lord_castle_region',
    
    # Locations
    '22222222-2222-2222-2222-222222222001': 'luminary_house',
    '22222222-2222-2222-2222-222222222002': 'village_square',
    '22222222-2222-2222-2222-222222222003': 'sacred_tor',
    '22222222-2222-2222-2222-222222222004': 'village_shop',
    '22222222-2222-2222-2222-222222222005': 'gemmas_house',
    '22222222-2222-2222-2222-222222222006': 'village_well',
    '22222222-2222-2222-2222-222222222007': 'training_grounds',
    '22222222-2222-2222-2222-222222222008': 'mayor_house',
    '22222222-2222-2222-2222-222222222009': 'forest_path',
    '22222222-2222-2222-2222-222222222010': 'bamboo_forest',
    
    # Story Chapters
    '33333333-3333-3333-3333-333333333001': 'ch01_luminary_awakening',
    '33333333-3333-3333-3333-333333333008': 'ch08_final_confrontation',
    
    # Story Events
    '66666666-6666-6666-6666-666666666001': 'event_ch01_birthday_awakening',
    '66666666-6666-6666-6666-666666666002': 'event_ch01_morning_training',
    '66666666-6666-6666-6666-666666666015': 'event_ch01_luminary_awakening',
    
    # Characters
    '44444444-4444-4444-4444-444444444001': 'luminary',
    '44444444-4444-4444-4444-444444444002': 'gemma',
    '44444444-4444-4444-4444-444444444003': 'chalky',
    '44444444-4444-4444-4444-444444444004': 'blacksmith_tom',
    '44444444-4444-4444-4444-444444444005': 'mayor',
    '44444444-4444-4444-4444-444444444006': 'village_elder',
    '44444444-4444-4444-4444-444444444007': 'herbalist',
    '44444444-4444-4444-4444-444444444008': 'merchant',
    '44444444-4444-4444-4444-444444444009': 'guard',
    '44444444-4444-4444-4444-444444444010': 'mysterious_traveler',
    
    # Items
    '55555555-5555-5555-5555-555555555001': 'cobblestone_sword',
    '55555555-5555-5555-5555-555555555002': 'healing_herb',
    '55555555-5555-5555-5555-555555555003': 'magic_water',
    '55555555-5555-5555-5555-555555555004': 'leather_armor',
    '55555555-5555-5555-5555-555555555005': 'wooden_shield',
    '55555555-5555-5555-5555-555555555006': 'iron_sword',
    '55555555-5555-5555-5555-555555555007': 'chain_mail',
    '55555555-5555-5555-5555-555555555008': 'steel_shield',
    '55555555-5555-5555-5555-555555555009': 'herbal_medicine',
    '55555555-5555-5555-5555-555555555010': 'elixir',
    '55555555-5555-5555-5555-555555555011': 'antidote',
    '55555555-5555-5555-5555-555555555012': 'holy_water',
    '55555555-5555-5555-5555-555555555013': 'lucky_charm',
    '55555555-5555-5555-5555-555555555014': 'training_gloves',
    
    # Event Interactions
    '77777777-7777-7777-7777-777777777001': 'interaction_talk_to_chalky',
    '77777777-7777-7777-7777-777777777002': 'interaction_examine_room',
    '77777777-7777-7777-7777-777777777003': 'interaction_check_inventory',
    '77777777-7777-7777-7777-777777777004': 'interaction_look_out_window',
    '77777777-7777-7777-7777-777777777005': 'interaction_training_practice',
    '77777777-7777-7777-7777-777777777006': 'interaction_sword_techniques',
    '77777777-7777-7777-7777-777777777007': 'interaction_rest',
    '77777777-7777-7777-7777-777777777008': 'interaction_examine_decorations',
    '77777777-7777-7777-7777-777777777009': 'interaction_talk_to_mayor',
    '77777777-7777-7777-7777-777777777010': 'interaction_talk_to_gemma',
    '77777777-7777-7777-7777-777777777011': 'interaction_examine_festival',
    '77777777-7777-7777-7777-777777777012': 'interaction_village_activities',
    '77777777-7777-7777-7777-777777777013': 'interaction_forest_meditation',
    '77777777-7777-7777-7777-777777777014': 'interaction_collect_herbs',
    '77777777-7777-7777-7777-777777777015': 'interaction_bamboo_ritual',
    '77777777-7777-7777-7777-777777777016': 'interaction_ancient_knowledge',
    '77777777-7777-7777-7777-777777777017': 'interaction_listen_to_traveler',
    '77777777-7777-7777-7777-777777777018': 'interaction_traveler_stories',
    '77777777-7777-7777-7777-777777777019': 'interaction_world_knowledge',
    '77777777-7777-7777-7777-777777777020': 'interaction_mysterious_advice',
    '77777777-7777-7777-7777-777777777021': 'interaction_hidden_truth',
    '77777777-7777-7777-7777-777777777022': 'interaction_destiny_revelation',
    '77777777-7777-7777-7777-777777777023': 'interaction_the_awakening',
    
    # Event Outcomes
    '88888888-8888-8888-8888-888888888001': 'outcome_ready_choice',
    '88888888-8888-8888-8888-888888888002': 'outcome_nervous_choice',
    '88888888-8888-8888-8888-888888888003': 'outcome_curious_choice',
    '88888888-8888-8888-8888-888888888004': 'outcome_training_complete',
    '88888888-8888-8888-8888-888888888005': 'outcome_sword_mastery',
    '88888888-8888-8888-8888-888888888006': 'outcome_rested',
    '88888888-8888-8888-8888-888888888007': 'outcome_festival_joy',
    '88888888-8888-8888-8888-888888888008': 'outcome_mayor_blessing',
    '88888888-8888-8888-8888-888888888009': 'outcome_gemma_encouragement',
    '88888888-8888-8888-8888-888888888010': 'outcome_village_harmony',
    '88888888-8888-8888-8888-888888888011': 'outcome_forest_wisdom',
    '88888888-8888-8888-8888-888888888012': 'outcome_herbs_collected',
    '88888888-8888-8888-8888-888888888013': 'outcome_bamboo_power',
    '88888888-8888-8888-8888-888888888014': 'outcome_ancient_secrets',
    '88888888-8888-8888-8888-888888888015': 'outcome_traveler_guidance',
    '88888888-8888-8888-8888-888888888016': 'outcome_world_wisdom',
    '88888888-8888-8888-8888-888888888017': 'outcome_mysterious_insight',
    '88888888-8888-8888-8888-888888888018': 'outcome_truth_revealed',
    '88888888-8888-8888-8888-888888888019': 'outcome_destiny_understood',
    '88888888-8888-8888-8888-888888888020': 'outcome_luminary_awakened',
}

def convert_sql_file(input_path, output_path):
    """Convert UUID references in SQL file to readable codes"""
    
    with open(input_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace UUID values with readable codes
    for uuid, code in UUID_MAPPINGS.items():
        # Replace UUID in VALUES clauses
        content = re.sub(
            rf"'{uuid}'(?=\s*,|\s*\))",
            f"public.generate_uuid_from_code('{code}')",
            content
        )
        
        # Replace UUID in JSON references
        content = re.sub(
            rf'"{uuid}"',
            f'"{code}"',
            content
        )
    
    # Replace UUID references in foreign key relationships
    # This is more complex and might need manual adjustment
    
    # Add header comment
    header = """-- Dragon Quest XI Story Data Seed - Converted to Readable Codes
-- Generated from UUID-based seed file
-- Uses helper functions for readable code management
-- Run this after applying the readable codes migration

"""
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(header + content)
    
    print(f"Converted {input_path} -> {output_path}")

def generate_mapping_report():
    """Generate a report of UUID to code mappings"""
    
    print("=== UUID to Code Mappings ===")
    print()
    
    categories = {
        'World Regions': [k for k in UUID_MAPPINGS.keys() if k.startswith('11111111')],
        'Locations': [k for k in UUID_MAPPINGS.keys() if k.startswith('22222222')],
        'Story Chapters': [k for k in UUID_MAPPINGS.keys() if k.startswith('33333333')],
        'Story Events': [k for k in UUID_MAPPINGS.keys() if k.startswith('66666666')],
        'Characters': [k for k in UUID_MAPPINGS.keys() if k.startswith('44444444')],
        'Items': [k for k in UUID_MAPPINGS.keys() if k.startswith('55555555')],
        'Event Interactions': [k for k in UUID_MAPPINGS.keys() if k.startswith('77777777')],
        'Event Outcomes': [k for k in UUID_MAPPINGS.keys() if k.startswith('88888888')],
    }
    
    for category, uuids in categories.items():
        print(f"### {category}")
        for uuid in sorted(uuids):
            code = UUID_MAPPINGS[uuid]
            print(f"  {uuid} -> {code}")
        print()

def main():
    if len(sys.argv) < 3:
        print("Usage: python convert_uuid_to_readable.py <input_file> <output_file>")
        print("Or: python convert_uuid_to_readable.py --report")
        sys.exit(1)
    
    if sys.argv[1] == "--report":
        generate_mapping_report()
        return
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    if not Path(input_file).exists():
        print(f"Error: Input file '{input_file}' not found")
        sys.exit(1)
    
    convert_sql_file(input_file, output_file)
    print("Conversion completed!")

if __name__ == "__main__":
    main()
