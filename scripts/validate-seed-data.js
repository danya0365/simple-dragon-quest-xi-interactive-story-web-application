#!/usr/bin/env node

/**
 * Seed Data Validation Script
 * Validates Dragon Quest story data for completeness and consistency
 * 
 * Usage: node scripts/validate-seed-data.js
 */

const fs = require('fs');
const path = require('path');

// Validation Rules
const VALIDATION_RULES = {
    // Every outcome must have either next_event_id or unlock_events effects
    outcomeMustHaveProgression: {
        name: 'Outcome Progression Check',
        description: 'Every outcome must have either next_event_id or unlock_events effects',
        validate: (outcome) => {
            const hasNextEvent = outcome.next_event_id !== null && outcome.next_event_id !== undefined;
            const hasUnlockEvents = outcome.effects && 
                                  JSON.parse(outcome.effects).unlock_events && 
                                  JSON.parse(outcome.effects).unlock_events.length > 0;
            return hasNextEvent || hasUnlockEvents;
        },
        errorMessage: (outcome) => 
            `Outcome "${outcome.title}" (ID: ${outcome.id}) must have either next_event_id or unlock_events effects`
    },

    // Events must have at least one interaction
    eventMustHaveInteractions: {
        name: 'Event Interactions Check',
        description: 'Every event must have at least one interaction',
        validate: (event, interactions) => {
            return interactions.some(interaction => interaction.event_id === event.id);
        },
        errorMessage: (event) => 
            `Event "${event.title}" (ID: ${event.id}) must have at least one interaction`
    },

    // Interactions must have at least one outcome
    interactionMustHaveOutcomes: {
        name: 'Interaction Outcomes Check',
        description: 'Every interaction must have at least one outcome',
        validate: (interaction, outcomes) => {
            return outcomes.some(outcome => outcome.interaction_id === interaction.id);
        },
        errorMessage: (interaction) => 
            `Interaction "${interaction.title}" (ID: ${interaction.id}) must have at least one outcome`
    },

    // Next event IDs must reference existing events
    nextEventMustExist: {
        name: 'Next Event Existence Check',
        description: 'All next_event_id must reference existing events',
        validate: (outcome, events) => {
            if (!outcome.next_event_id) return true;
            return events.some(event => event.id === outcome.next_event_id);
        },
        errorMessage: (outcome) => 
            `Outcome "${outcome.title}" references non-existent next_event_id: ${outcome.next_event_id}`
    },

    // Unlock events must reference existing events
    unlockEventsMustExist: {
        name: 'Unlock Events Existence Check',
        description: 'All unlock_events must reference existing events',
        validate: (outcome, events) => {
            if (!outcome.effects) return true;
            try {
                const effects = JSON.parse(outcome.effects);
                if (!effects.unlock_events) return true;
                
                return effects.unlock_events.every(eventId => 
                    events.some(event => event.id === eventId)
                );
            } catch (e) {
                return false;
            }
        },
        errorMessage: (outcome) => 
            `Outcome "${outcome.title}" has unlock_events that reference non-existent events`
    },

    // Effects JSON must be valid
    effectsMustBeValidJson: {
        name: 'Effects JSON Validation',
        description: 'All effects must be valid JSON',
        validate: (outcome) => {
            if (!outcome.effects) return true;
            try {
                JSON.parse(outcome.effects);
                return true;
            } catch (e) {
                return false;
            }
        },
        errorMessage: (outcome) => 
            `Outcome "${outcome.title}" has invalid JSON in effects field`
    }
};

class SeedDataValidator {
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
            
            // Extract INSERT statements for each table
            this.extractInsertStatements(content, 'story_events', this.data.events);
            this.extractInsertStatements(content, 'event_interactions', this.data.interactions);
            this.extractInsertStatements(content, 'event_outcomes', this.data.outcomes);
            
            console.log(`✅ Found ${this.data.events.length} events`);
            console.log(`✅ Found ${this.data.interactions.length} interactions`);
            console.log(`✅ Found ${this.data.outcomes.length} outcomes`);
            
        } catch (error) {
            throw new Error(`Failed to read seed file: ${error.message}`);
        }
    }

    extractInsertStatements(content, tableName, targetArray) {
        // Simple but effective regex to match INSERT statements
        const regex = new RegExp(`INSERT INTO public\\.${tableName}.*?VALUES.*?\\((.*?)\\);`, 'gs');
        let match;
        
        while ((match = regex.exec(content)) !== null) {
            const valuesContent = match[1];
            // Split by '),(' but handle nested quotes and parentheses
            const values = this.splitSqlValues(valuesContent);
            values.forEach(valueStr => {
                const row = this.parseRowValues(valueStr);
                if (row) {
                    targetArray.push(row);
                }
            });
        }
    }
    
    splitSqlValues(valuesContent) {
        const values = [];
        let current = '';
        let inQuotes = false;
        let parenDepth = 0;
        
        for (let i = 0; i < valuesContent.length; i++) {
            const char = valuesContent[i];
            
            if (char === "'" && (i === 0 || valuesContent[i-1] !== '\\')) {
                inQuotes = !inQuotes;
                current += char;
            } else if (char === '(' && !inQuotes) {
                parenDepth++;
                current += char;
            } else if (char === ')' && !inQuotes) {
                parenDepth--;
                current += char;
            } else if (char === ',' && !inQuotes && parenDepth === 0) {
                values.push(current.trim());
                current = '';
            } else {
                current += char;
            }
        }
        
        if (current.trim()) {
            values.push(current.trim());
        }
        
        return values;
    }

    parseRowValues(valueStr) {
        try {
            // Remove outer quotes and split by commas, but handle quoted strings
            const values = [];
            let current = '';
            let inQuotes = false;
            
            for (let i = 0; i < valueStr.length; i++) {
                const char = valueStr[i];
                
                if (char === "'" && (i === 0 || valueStr[i-1] !== '\\')) {
                    inQuotes = !inQuotes;
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
                story_events: ['id', 'chapter_id', 'location_id', 'title', 'description', 'event_type', 'is_unlocked', 'display_order'],
                event_interactions: ['id', 'event_id', 'interaction_type', 'title', 'description', 'dialogue_text', 'character_speaker', 'choices', 'display_order'],
                event_outcomes: ['id', 'interaction_id', 'choice_id', 'outcome_type', 'title', 'description', 'effects', 'next_event_id']
            };
            
            const tableName = Object.keys(columns).find(key => 
                valueStr.includes(key) || this.data.events.length > 0
            );
            
            const currentColumns = tableName ? columns[tableName] : 
                ['id', 'interaction_id', 'choice_id', 'outcome_type', 'title', 'description', 'effects', 'next_event_id'];
            
            const row = {};
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
        
        Object.entries(VALIDATION_RULES).forEach(([ruleKey, rule]) => {
            console.log(`\n📋 ${rule.name}: ${rule.description}`);
            
            switch (ruleKey) {
                case 'outcomeMustHaveProgression':
                    this.data.outcomes.forEach(outcome => {
                        if (!rule.validate(outcome)) {
                            this.errors.push(rule.errorMessage(outcome));
                        }
                    });
                    break;
                    
                case 'eventMustHaveInteractions':
                    this.data.events.forEach(event => {
                        if (!rule.validate(event, this.data.interactions)) {
                            this.errors.push(rule.errorMessage(event));
                        }
                    });
                    break;
                    
                case 'interactionMustHaveOutcomes':
                    this.data.interactions.forEach(interaction => {
                        if (!rule.validate(interaction, this.data.outcomes)) {
                            this.errors.push(rule.errorMessage(interaction));
                        }
                    });
                    break;
                    
                case 'nextEventMustExist':
                    this.data.outcomes.forEach(outcome => {
                        if (!rule.validate(outcome, this.data.events)) {
                            this.errors.push(rule.errorMessage(outcome));
                        }
                    });
                    break;
                    
                case 'unlockEventsMustExist':
                    this.data.outcomes.forEach(outcome => {
                        if (!rule.validate(outcome, this.data.events)) {
                            this.errors.push(rule.errorMessage(outcome));
                        }
                    });
                    break;
                    
                case 'effectsMustBeValidJson':
                    this.data.outcomes.forEach(outcome => {
                        if (!rule.validate(outcome)) {
                            this.errors.push(rule.errorMessage(outcome));
                        }
                    });
                    break;
            }
        });
        
        this.generateWarnings();
    }

    generateWarnings() {
        // Check for events without proper progression paths
        this.data.events.forEach(event => {
            const eventOutcomes = this.data.outcomes.filter(outcome => {
                const interaction = this.data.interactions.find(i => i.id === outcome.interaction_id);
                return interaction && interaction.event_id === event.id;
            });
            
            const hasProgression = eventOutcomes.some(outcome => 
                outcome.next_event_id || 
                (outcome.effects && JSON.parse(outcome.effects).unlock_events)
            );
            
            if (!hasProgression) {
                this.warnings.push(
                    `Event "${event.title}" (ID: ${event.id}) has no progression paths - all outcomes lead to dead ends`
                );
            }
        });
        
        // Check for orphaned interactions (no event)
        this.data.interactions.forEach(interaction => {
            if (!this.data.events.some(event => event.id === interaction.event_id)) {
                this.warnings.push(
                    `Interaction "${interaction.title}" (ID: ${interaction.id}) references non-existent event`
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
    const validator = new SeedDataValidator();
    validator.run();
}

module.exports = SeedDataValidator;
