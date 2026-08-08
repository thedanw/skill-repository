$content = Get-Content '.agents/skills/boss/00-setup/agents-md/SKILL.md' -Raw -Encoding UTF8
if ($content -match '(?s)---\s*\n(.*?)\n---') {
    $frontmatter = $matches[1]
    if ($frontmatter -match '(?m)^description:\s*(.+)') {
        $desc = $matches[1].Trim().Trim('"').Trim("'")
        Write-Host "Original: '$desc'"
        
        # Test the function logic inline
        $patterns = @(
            @{pattern = '^Refine and optimize (.+)'; replacement = 'Improve $1: rewrite, add examples, tune parameters'},
            @{pattern = '^Fetch the exact wording of (.+)'; replacement = 'Retrieve $1: exact lookup for study or reference'},
            @{pattern = '^Transform (.+) into (.+)'; replacement = 'Convert $1 to $2: transform for $2'},
            @{pattern = '^Generate (.+)'; replacement = 'Create $1: generate from input'},
            @{pattern = '^Analyze (.+)'; replacement = 'Analyze $1: inspect and report findings'},
            @{pattern = '^Optimize (.+)'; replacement = 'Optimize $1: improve performance/efficiency'},
            @{pattern = '^Debug (.+)'; replacement = 'Debug $1: find and fix issues'},
            @{pattern = '^Test (.+)'; replacement = 'Test $1: verify functionality'},
            @{pattern = '^Deploy (.+)'; replacement = 'Deploy $1: release to environment'},
            @{pattern = '^Build (.+)'; replacement = 'Build $1: compile and package'},
            @{pattern = '^Create (.+)'; replacement = 'Create $1: generate new'},
            @{pattern = '^Manage (.+)'; replacement = 'Manage $1: administer and configure'},
            @{pattern = '^Monitor (.+)'; replacement = 'Monitor $1: observe and alert'},
            @{pattern = '^Sync (.+)'; replacement = 'Sync $1: synchronize across systems'},
            @{pattern = '^Convert (.+)'; replacement = 'Convert $1: transform format'},
            @{pattern = '^Validate (.+)'; replacement = 'Validate $1: check correctness'},
            @{pattern = '^Extract (.+)'; replacement = 'Extract $1: pull data from source'},
            @{pattern = '^Research (.+)'; replacement = 'Research $1: investigate and synthesize'},
            @{pattern = '^Plan (.+)'; replacement = 'Plan $1: design approach and steps'},
            @{pattern = '^Design (.+)'; replacement = 'Design $1: architect solution'},
            @{pattern = '^Write (.+)'; replacement = 'Write $1: produce content'},
            @{pattern = '^Review (.+)'; replacement = 'Review $1: evaluate quality'},
            @{pattern = '^Audit (.+)'; replacement = 'Audit $1: inspect compliance'},
            @{pattern = '^Use before (.+)'; replacement = '$1: use before implementation'},
            @{pattern = '^Use for (.+)'; replacement = '$1: use for this purpose'},
            @{pattern = '^Use to (.+)'; replacement = '$1: use to accomplish this'},
            @{pattern = '^Helps (.+)'; replacement = '$1: helps with this task'},
            @{pattern = '^Enables (.+)'; replacement = '$1: enables this capability'},
            @{pattern = '^Provides (.+)'; replacement = '$1: provides this functionality'},
            @{pattern = '^Allows (.+)'; replacement = '$1: allows this action'},
            @{pattern = '^Context optimization extends (.+)'; replacement = 'Reduce token usage for small-context LLMs: compression, caching, partitioning strategies'},
            @{pattern = '^(.+) extends the effective capacity (.+)'; replacement = 'Reduce token usage: $1 strategies for limited context windows'},
            @{pattern = '^(.+), use when (.+)'; replacement = '$1: use when $2'},
            @{pattern = '^(.+)\. Use when (.+)'; replacement = '$1: use when $2'},
            @{pattern = '^Create, update, or maintain (.+)'; replacement = 'Create, update, or maintain $1: agent documentation setup'},
            @{pattern = '^Create, update, or maintain (.+) files? with (.+)'; replacement = 'Create, update, or maintain $1 files: $2'}
        )
        
        $result = $desc
        foreach ($p in $patterns) {
            if ($result -match $p.pattern) {
                $result = $result -replace $p.pattern, $p.replacement
                Write-Host "Matched: $($p.pattern) -> '$result'"
                break
            }
        }
        
        if ($result -match '^(This|It|The|A|An|Use|Helps|Enables|Provides|Allows|Context|Create)\s') {
            $result = "Use for: $result"
        }
        
        if ($result.Length -gt 150) {
            $result = $result.Substring(0, 147) + "..."
        }
        
        Write-Host "Final: '$result'"
    }
}