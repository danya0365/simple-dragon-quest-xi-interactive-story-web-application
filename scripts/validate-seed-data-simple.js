#!/usr/bin/env node

/**
 * Simple Seed Data Validation Script
 * Validates Dragon Quest story data for completeness and consistency
 * 
 * Usage: node scripts/validate-seed-data-simple.js
 */

const fs = require('fs');
const path = require('path');

class SimpleSeedDataValidator {
    constructor() {
        this.seedFilePath = path.join(__dirname, '../supabase/seeds/001-dragon_quest_story_data.sql');
        this.errors = [];
        this.warnings = [];
        this.data = {
            events: [],
            interactions: [],
            outcomes: []
        };
    }

    parseSeedFile() {
        console.log('🔍 Parsing seed data file...');
        
        try {
            const content = fs.readFileSync(this.seedFilePath, 'utf8');
            
            // Simple line-by-line parsing
            const lines = content.split('\n');
            let currentTable = null;
            let insertStatement = '';
            
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i].trim();
                
                if (line.startsWith('INSERT INTO public.story_events')) {
                    currentTable = 'events';
                    insertStatement = line;
                } else if (line.startsWith('INSERT INTO public.event_interactions')) {
                    currentTable = 'interactions';
                    insertStatement = line;
                } else if (line.startsWith('INSERT INTO public.event_outcomes')) {
                    currentTable = 'outcomes';
                    insertStatement = line;
                } else if (currentTable && (line.endsWith(');') || line.endsWith(')'))) {
                    insertStatement += ' ' + line;
                    this.parseInsertStatement(insertStatement, currentTable);
                    currentTable = null;
                    insertStatement = '';
                } else if (currentTable) {
                    insertStatement += ' ' + line;
                }
            }
            
            console.log(`✅ Found ${this.data.events.length} events`);
            console.log(`✅ Found ${this.data.interactions.length} interactions`);
            console.log(`✅ Found ${this.data.outcomes.length} outcomes`);
            
        } catch (error) {
            throw new Error(`Failed to read seed file: ${error.message}`);
        }
    }

    parseInsertStatement(statement, tableType) {
        try {
            // Extract the VALUES part
            const valuesMatch = statement.match(/VALUES\s*\(([\s\S]*?)\);/);
            if (!valuesMatch) return;
            
            const valuesContent = valuesMatch[1];
            const rows = valuesContent.split('),\n(');
            
            rows.forEach(rowStr => {
                const row = this.parseRowValues(rowStr.trim(), tableType);
                if (row) {
                    this.data[tableType].push(row);
                }
            });
        } catch (error) {
            console.warn(`⚠️  Failed to parse statement: ${statement}`);
        }
    }

    parseRowValues(valueStr, tableType) {
        try {
            // Split by commas but respect quoted strings
            const values = [];
            let current = '';
            let inQuotes = false;
            
            for (let i = 0; i < valueStr.length; i++) {
                const char = valueStr[i];
                
                if (char === "'" && (i === 0 || valueStr[i-1] !== '\\')) {
                    inQuotes = !inQuotes;
                    current += char;
                } else if (char === ',' && !inQuotes) {
                    values.push(current.trim());
                    current = '';
                } else {
                    current += char;
                }
            }
            values.push(current.trim());
            
            // Define columns for each table
            const columns = {
                events: ['id', 'chapter_id', 'location_id', 'title', 'description', 'event_type', 'is_unlocked', 'display_order'],
                interactions: ['id', 'event_id', 'interaction_type', 'title', 'description', 'dialogue_text', 'character_speaker', 'choices', 'display_order'],
                outcomes: ['id', 'interaction_id', 'choice_id', 'outcome_type', 'title', 'description', 'effects', 'next_event_id']
            };
            
            const row = {};
            const currentColumns = columns[tableType];
            
            currentColumns.forEach((col, index) => {
                if (values[index]) {
                    // Remove quotes and handle NULL values
                    let value = values[index].replace(/^'|'$/g, '');
                    if (value === 'NULL' || value === 'null') {
                        value = null;
                    }
                    row[col] = value;
                }
            });
            
            return row;
            
        } catch (error) {
            console.warn(`⚠️  Failed to parse row: ${valueStr}`);
            return null;
        }
    }

    validate() {
        console.log('\n🔍 Running validation rules...');
        
        // Rule 1: Every outcome must have either next_event_id or unlock_events effects
        console.log('\n📋 Outcome Progression Check');
        this.data.outcomes.forEach(outcome => {
            const hasNextEvent = outcome.next_event_id && outcome.next_event_id !== 'null';
            const hasUnlockEvents = outcome.effects && outcome.effects.includes('unlock_events');
            
            if (!hasNextEvent && !hasUnlockEvents) {
                this.errors.push(
                    `Outcome "${outcome.title}" (ID: ${outcome.id}) must have either next_event_id or unlock_events effects`
                );
            }
        });
        
        // Rule 2: Events must have at least one interaction
        console.log('\n📋 Event Interactions Check');
        this.data.events.forEach(event => {
            const hasInteractions = this.data.interactions.some(interaction => 
                interaction.event_id === event.id
            );
            
            if (!hasInteractions) {
                this.errors.push(
                    `Event "${event.title}" (ID: ${event.id}) must have at least one interaction`
                );
            }
        });
        
        // Rule 3: Interactions must have at least one outcome
        console.log('\n📋 Interaction Outcomes Check');
        this.data.interactions.forEach(interaction => {
            const hasOutcomes = this.data.outcomes.some(outcome => 
                outcome.interaction_id === interaction.id
            );
            
            if (!hasOutcomes) {
                this.errors.push(
                    `Interaction "${interaction.title}" (ID: ${interaction.id}) must have at least one outcome`
                );
            }
        });
        
        // Rule 4: Next event IDs must reference existing events
        console.log('\n📋 Next Event Existence Check');
        this.data.outcomes.forEach(outcome => {
            if (outcome.next_event_id && outcome.next_event_id !== 'null') {
                const eventExists = this.data.events.some(event => 
                    event.id === outcome.next_event_id
                );
                
                if (!eventExists) {
                    this.errors.push(
                        `Outcome "${outcome.title}" references non-existent next_event_id: ${outcome.next_event_id}`
                    );
                }
            }
        });
        
        // Rule 5: Effects JSON must be valid
        console.log('\n📋 Effects JSON Validation');
        this.data.outcomes.forEach(outcome => {
            if (outcome.effects && outcome.effects !== 'null') {
                try {
                    JSON.parse(outcome.effects);
                } catch (e) {
                    this.errors.push(
                        `Outcome "${outcome.title}" has invalid JSON in effects field`
                    );
                }
            }
        });
        
        this.generateWarnings();
    }

    generateWarnings() {
        // Check for events without proper progression paths
        console.log('\n📋 Generating warnings...');
        this.data.events.forEach(event => {
            const eventOutcomes = this.data.outcomes.filter(outcome => {
                const interaction = this.data.interactions.find(i => i.id === outcome.interaction_id);
                return interaction && interaction.event_id === event.id;
            });
            
            const hasProgression = eventOutcomes.some(outcome => 
                (outcome.next_event_id && outcome.next_event_id !== 'null') || 
                (outcome.effects && outcome.effects.includes('unlock_events'))
            );
            
            if (!hasProgression) {
                this.warnings.push(
                    `Event "${event.title}" (ID: ${event.id}) has no progression paths - all outcomes lead to dead ends`
                );
            }
        });
    }

    report() {
        console.log('\n' + '='.repeat(60));
        console.log('📊 VALIDATION REPORT');
        console.log('='.repeat(60));
        
        if (this.errors.length === 0 && this.warnings.length === 0) {
            console.log('✅ All validation checks passed!');
            return true;
        }
        
        if (this.errors.length > 0) {
            console.log('\n❌ ERRORS:');
            this.errors.forEach((error, index) => {
                console.log(`   ${index + 1}. ${error}`);
            });
        }
        
        if (this.warnings.length > 0) {
            console.log('\n⚠️  WARNINGS:');
            this.warnings.forEach((warning, index) => {
                console.log(`   ${index + 1}. ${warning}`);
            });
        }
        
        console.log(`\n📈 Summary:`);
        console.log(`   Errors: ${this.errors.length}`);
        console.log(`   Warnings: ${this.warnings.length}`);
        
        return this.errors.length === 0;
    }

    run() {
        try {
            console.log('🚀 Starting seed data validation...\n');
            
            this.parseSeedFile();
            this.validate();
            const isValid = this.report();
            
            if (!isValid) {
                console.log('\n💡 Recommendations:');
                console.log('   1. Fix all errors before committing changes');
                console.log('   2. Review warnings for potential improvements');
                console.log('   3. Run this script as part of your pre-commit hooks');
                console.log('   4. Add automated tests to prevent regression');
                
                process.exit(1);
            } else {
                console.log('\n🎉 Seed data validation completed successfully!');
                process.exit(0);
            }
            
        } catch (error) {
            console.error(`💥 Validation failed: ${error.message}`);
            process.exit(1);
        }
    }
}

// Run validation if this script is executed directly
if (require.main === module) {
    const validator = new SimpleSeedDataValidator();
    validator.run();
}

module.exports = SimpleSeedDataValidator;
