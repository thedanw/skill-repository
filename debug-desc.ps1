$desc = 'Use before any creative or constructive work (features, architecture, behavior). Transforms vague ideas into validated designs through disciplined dialogue. Outputs decision tree to decision.md for pipeline integration.'
$tags = @('brainstorming', 'design', 'planning', 'collaboration', 'requirements', 'architecture', 'decision-tree')
$name = '01_brainstorming'

# Test Generate-SkillDescription logic
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
    @{pattern = '^Audit (.+)'; replacement = 'Audit $1: inspect compliance'}
)

$result = $desc
foreach ($p in $patterns) {
    if ($result -match $p.pattern) {
        $result = $result -replace $p.pattern, $p.replacement
        Write-Host "Matched pattern: $($p.pattern)"
        break
    }
}

if ($result -match '^(This|It|The|A|An)\s') {
    $result = "Use for: $result"
}

Write-Host "Result: '$result'"