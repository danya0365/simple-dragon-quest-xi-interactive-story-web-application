#!/usr/bin/env node

/**
 * Debug script to test SQL parsing
 */

const fs = require('fs');
const path = require('path');

function debugSeedFile() {
    const seedFilePath = path.join(__dirname, '../supabase/seeds/001-dragon_quest_story_data.sql');
    const content = fs.readFileSync(seedFilePath, 'utf8');
    
    console.log('=== DEBUG: First 500 characters ===');
    console.log(content.substring(0, 500));
    
    console.log('\n=== DEBUG: Looking for INSERT statements ===');
    
    // Find all INSERT statements
    const eventInserts = content.match(/INSERT INTO public\.story_events[^;]+;/gs);
    const interactionInserts = content.match(/INSERT INTO public\.event_interactions[^;]+;/gs);
    const outcomeInserts = content.match(/INSERT INTO public\.event_outcomes[^;]+;/gs);
    
    console.log(`Found ${eventInserts ? eventInserts.length : 0} event INSERT statements`);
    console.log(`Found ${interactionInserts ? interactionInserts.length : 0} interaction INSERT statements`);
    console.log(`Found ${outcomeInserts ? outcomeInserts.length : 0} outcome INSERT statements`);
    
    if (eventInserts && eventInserts.length > 0) {
        console.log('\n=== DEBUG: First event INSERT ===');
        console.log(eventInserts[0]);
        
        // Try to extract VALUES
        const valuesMatch = eventInserts[0].match(/VALUES\s*\(([\s\S]*?)\);/);
        if (valuesMatch) {
            console.log('\n=== DEBUG: VALUES content ===');
            console.log(valuesMatch[1]);
            
            // Try to split rows
            const rows = valuesMatch[1].split('),\n(');
            console.log(`\n=== DEBUG: Found ${rows.length} rows ===`);
            rows.forEach((row, index) => {
                console.log(`Row ${index + 1}: ${row.substring(0, 100)}...`);
            });
        }
    }
}

debugSeedFile();
