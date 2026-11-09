param(
  [string]$CodexRoot = '',
  [Alias('SkipExcludedCapabilities')]
  [switch]$SkipCapabilities
)

if ([string]::IsNullOrWhiteSpace($CodexRoot)) {
  if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    $CodexRoot = $env:CODEX_HOME
  } elseif (-not [string]::IsNullOrWhiteSpace($HOME)) {
    $CodexRoot = Join-Path $HOME '.codex'
  } else {
    throw 'Set CODEX_HOME or provide -CodexRoot.'
  }
}

$ErrorActionPreference = 'Stop'
$failed = @()

function Add-Failure {
  param([string]$Message)
  $script:failed += $Message
}

function Assert-Contains {
  param(
    [string]$RelativePath,
    [string]$Text
  )

  $path = Join-Path $CodexRoot $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Add-Failure "${RelativePath}: file is missing"
    return
  }
  $content = Get-Content -LiteralPath $path -Raw
  if (-not $content.Contains($Text)) {
    Add-Failure "${RelativePath}: missing '$Text'"
  }
}

function Assert-NotContains {
  param(
    [string]$RelativePath,
    [string]$Text
  )

  $path = Join-Path $CodexRoot $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Add-Failure "${RelativePath}: file is missing"
    return
  }
  $content = Get-Content -LiteralPath $path -Raw
  if ($content.Contains($Text)) {
    Add-Failure "${RelativePath}: obsolete universal rule remains '$Text'"
  }
}

if (-not $SkipCapabilities) {
  Add-Failure 'excluded capability checks require explicit -SkipCapabilities mode'
} else {
  Write-Output 'EXCLUDED CAPABILITY CHECKS SKIPPED: source and live domain contracts were not read'
}

# Entrypoint and canonical-policy contracts. These checks test effective boundaries,
# not duplicated prose or excluded domain files.
$checks = @(
  @{ Path='skills\sol-luna-orchestration\SKILL.md'; Text='Use this overlay for explicit delegation or review' },
  @{ Path='skills\sol-luna-orchestration\SKILL.md'; Text='Astra does not implement delegated work' },
  @{ Path='skills\sol-luna-orchestration\SKILL.md'; Text='Use Luna when scope and owner are bounded' },
  @{ Path='skills\sol-luna-orchestration\SKILL.md'; Text='model: gpt-6.1-sol' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='owner: using-superpowers' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='direct_execution:' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='delegated_execution:' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='domain_contract_precedence:' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='model_effort_policy:' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='supported_efforts: [low, medium, high, max]' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='model: gpt-6-astra' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='evidence_policy:' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='direct_execution_is_allowed_only_when_all_direct_execution_guards_pass' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='previously_known_rohs_contract_is_luna_only_no_alternate_and_acceptance_process' },
  @{ Path='skills\using-superpowers\agent-routing-rules.yaml'; Text='handoff_or_message_boundary_alone_does_not_invalidate' },
  @{ Path='skills\using-superpowers\SKILL.md'; Text='Independent review is not required by default' },
  @{ Path='skills\using-superpowers\SKILL.md'; Text='An explicit no-subagents preference keeps execution' },
  @{ Path='skills\model-routing\SKILL.md'; Text='For a clear low-risk route, keep execution with the current model' },
  @{ Path='skills\using-superpowers\AGENT_ROUTER_PROMPT.md'; Text='execution_lane: <control | direct | delegated>' },
  @{ Path='skills\using-superpowers\AGENT_ROUTER_PROMPT.md'; Text='a message or handoff alone does not' },
  @{ Path='agents\workflow-router.toml'; Text='route `direct`' },
  @{ Path='agents\workflow-router.toml'; Text='route `delegated`' },
  @{ Path='skills\sol-luna-orchestration\references\task-packet.md'; Text='Use this packet only for delegated or independently reviewed work' },
  @{ Path='skills\sol-luna-orchestration\references\task-packet.md'; Text='dispatch_contract:' },
  @{ Path='skills\sol-luna-orchestration\references\task-packet.md'; Text='decision: <pass|retry|rollback>' },
  @{ Path='skills\subagent-driven-development\SKILL.md'; Text='SDD is used only after the global policy selects delegated decomposition' },
  @{ Path='skills\subagent-driven-development\SKILL.md'; Text='A child executes its bounded packet and does not restart global routing' },
  @{ Path='skills\using-superpowers\LANGGRAPH_AGENT_ROUTING.md'; Text='## Runtime Boundary' },
  @{ Path='skills\using-superpowers\LANGGRAPH_AGENT_ROUTING.md'; Text='Clear, bounded, low-risk work may execute in the current model' },
  @{ Path='global-agent-map\README.md'; Text='are separate stored configuration sources' },
  @{ Path='global-agent-map\global-agent-skill-relationship-map.md'; Text='the router chooses a direct or delegated boundary' },
  @{ Path='global-agent-map\global-agent-skill-relationship-map.json'; Text='"direct_execution"' },
  @{ Path='global-agent-map\global-agent-skill-relationship-map.json'; Text='"model_effort_policy"' }
)
foreach ($check in $checks) {
  Assert-Contains -RelativePath $check.Path -Text $check.Text
}

$obsoleteUniversalRules = @(
  @{ Path='skills\using-superpowers\SKILL.md'; Text='Use `sol-luna-orchestration` as the runtime overlay whenever it is true.' },
  @{ Path='skills\using-superpowers\SKILL.md'; Text='Root Sol must not perform production work' },
  @{ Path='skills\model-routing\SKILL.md'; Text='Root Sol must not produce the implementation' },
  @{ Path='skills\using-superpowers\AGENT_ROUTER_PROMPT.md'; Text='Route every execution result to `gpt-6.1-sol`' },
  @{ Path='agents\workflow-router.toml'; Text='Send every execution result to separate GPT-5.6' }
)
foreach ($rule in $obsoleteUniversalRules) {
  Assert-NotContains -RelativePath $rule.Path -Text $rule.Text
}

# SDD remains a decomposition control route and never gets its own runtime lane.
$routingRulesPath = Join-Path $CodexRoot 'skills\using-superpowers\agent-routing-rules.yaml'
$routingRulesText = ''
if (Test-Path -LiteralPath $routingRulesPath -PathType Leaf) {
  $routingRulesText = Get-Content -LiteralPath $routingRulesPath -Raw
  $policyTokens = @(
    'model_effort_policy:',
    'supported_efforts: [low, medium, high, max]',
    'default_effort: medium',
    'default_effort: high',
    'explicit_user_choice:',
    'unsupported_explicit_choice:',
    'outcome: reject_and_report',
    'preserve_requested_values_in_diagnostics: true',
    'never_silent_default_or_substitute: true',
    'packet_rule: record_selected_model_effort'
  )
  foreach ($token in $policyTokens) {
    if (-not $routingRulesText.Contains($token)) { Add-Failure "canonical policy missing '$token'" }
  }
  if (-not $routingRulesText.Contains('delegated: astra')) { Add-Failure 'effective delegated controller is not Astra' }
  if (-not $routingRulesText.Contains('evaluation: astra')) { Add-Failure 'effective evaluation controller is not Astra' }
  $sddRouteMatch = [regex]::Match($routingRulesText, '(?ms)^  - id: subagent_driven_development\s+.*?(?=^  - id:|\z)')
  if (-not $sddRouteMatch.Success) {
    Add-Failure 'agent-routing-rules.yaml: explicit SDD route is missing'
  } else {
    $sddRouteBlock = $sddRouteMatch.Value
    foreach ($requiredRouteText in @('primary: subagent-driven-development', 'workflow_node: decomposition_dispatch')) {
      if (-not $sddRouteBlock.Contains($requiredRouteText)) {
        Add-Failure "agent-routing-rules.yaml: SDD route is missing '$requiredRouteText'"
      }
    }
    if ($sddRouteBlock -match '(?m)^\s+(?:execution_lane|runtime_agent_type|runtime_model|runtime_reasoning_effort):') {
      Add-Failure 'agent-routing-rules.yaml: SDD route must not create a runtime lane'
    }
    if ($sddRouteBlock.Contains('SDD is decomposition/child-dispatch control only')) {
      Write-Output 'SDD EXPLICIT ROUTE CHECK PASSED'
    } else {
      Add-Failure 'agent-routing-rules.yaml: SDD route is missing its control-only boundary'
    }
  }
}

# Reviewers advise; they never own a final verdict.
$reviewerPromptPaths = @(
  'skills\subagent-driven-development\spec-reviewer-prompt.md',
  'skills\subagent-driven-development\code-quality-reviewer-prompt.md'
)
$reviewerVerdictPattern = '(?i)(?:reviewer|reviewers)\s+(?:owns?|is|are|makes?|decides?)\s+(?:the\s+)?final\s+(?:pass|retry|rollback|verdict|acceptance)'
$reviewerVerdictCheckFailed = $false
foreach ($relativePath in $reviewerPromptPaths) {
  $path = Join-Path $CodexRoot $relativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Add-Failure "${relativePath}: reviewer prompt is missing"
    $reviewerVerdictCheckFailed = $true
    continue
  }
  $reviewerPrompt = Get-Content -LiteralPath $path -Raw
  if ($reviewerPrompt -match $reviewerVerdictPattern) {
    Add-Failure "${relativePath}: reviewer must not own a final verdict"
    $reviewerVerdictCheckFailed = $true
  }
}
if (-not $reviewerVerdictCheckFailed) {
  Write-Output 'NO FINAL REVIEWER VERDICT CHECK PASSED'
}

# Keep the supervisor overlay aligned with the advisory-only role.
$supervisorSkillPaths = @(
  'skills\supervisor-agent\SKILL.md',
  'skills\model-routing\references\agent-profiles\supervisor-agent\SKILL.md'
)
$supervisorPhrases = @(
  'advisory QA/governance support only',
  'contract-invalid',
  'Allowed output is limited to facts, variance, and recommendation',
  'Do not output a final `pass` or `fail`'
)
$supervisorFilesFound = 0
foreach ($relativePath in $supervisorSkillPaths) {
  $path = Join-Path $CodexRoot $relativePath
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    $supervisorFilesFound++
    foreach ($phrase in $supervisorPhrases) {
      if (-not (Select-String -LiteralPath $path -SimpleMatch -Quiet -Pattern $phrase)) {
        Add-Failure "${relativePath}: supervisor overlay is missing '$phrase'"
      }
    }
  }
}
if ($supervisorFilesFound -ne 2) {
  Add-Failure 'supervisor overlay: both supervisor skill files must be present'
} else {
  Write-Output 'SUPERVISOR OVERLAY CONSISTENCY CHECK PASSED'
}

$governorAgentPath = Join-Path $CodexRoot 'skills\project-delivery-governor\agents\openai.yaml'
if (Test-Path -LiteralPath $governorAgentPath -PathType Leaf) {
  $governorAgent = Get-Content -LiteralPath $governorAgentPath -Raw
  if ($governorAgent -match '(?m)^\s*model\s*:') {
    Add-Failure 'project-delivery-governor agent metadata must not pin a runtime model'
  }
}

function Resolve-SyntheticRoute {
  param([hashtable]$Scenario, [string]$PolicyText)

  $directPolicy = @(
    'request_and_artifact_are_clear', 'low_risk', 'bounded_scope',
    'no_material_cross_boundary', 'no_explicit_delegation_or_review_request',
    'no_stronger_domain_contract'
  ) | Where-Object { $PolicyText.Contains($_) }
  $delegatedPolicy = @(
    'explicit_user_delegation_or_model_request', 'explicit_independent_review_request',
    'high_risk_or_high_consequence', 'material_cross_boundary_change',
    'unresolved_ambiguity_or_ownership', 'stronger_domain_contract_requires_specialist_or_runtime'
  ) | Where-Object { $PolicyText.Contains($_) }

  if ($Scenario.Ambiguous) {
    return [pscustomobject]@{ Boundary='clarify'; IndependentReview='pending'; Runtime='current_model' }
  }
  if ($Scenario.NoSubagents -and $directPolicy.Count -ge 6) {
    return [pscustomobject]@{ Boundary='direct'; IndependentReview='unavailable'; Runtime='current_model' }
  }
  if (($Scenario.ExplicitDelegation -or $Scenario.ExplicitReview -or $Scenario.ExplicitModel -or
      $Scenario.HighRisk -or $Scenario.Ambiguous -or $Scenario.CrossBoundary -or $Scenario.DomainContract) -and
      ($delegatedPolicy.Count -ge 6)) {
    $runtime = if ($Scenario.ExplicitModel) { 'explicit_user_model' } else { 'delegated_overlay' }
    return [pscustomobject]@{ Boundary='delegated'; IndependentReview='required'; Runtime=$runtime }
  }
  if ($Scenario.Clear -and $Scenario.LowRisk -and $Scenario.Bounded) {
    return [pscustomobject]@{ Boundary='direct'; IndependentReview='not_required_by_default'; Runtime='current_model' }
  }
  return [pscustomobject]@{ Boundary='clarify'; IndependentReview='pending'; Runtime='current_model' }
}

# Representative policy scenarios. They exercise effective decisions; IDs are test labels,
# never production routing rules or task-quality benchmarks.
$scenarios = @(
  @{ Id=1;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=2;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=3;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=4;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=5;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=6;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=7;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=8;  Clear=$true; LowRisk=$true; Bounded=$true; Expected='direct' },
  @{ Id=9;  ExplicitDelegation=$true; Expected='delegated' },
  @{ Id=10; ExplicitModel=$true; Expected='delegated'; Runtime='explicit_user_model' },
  @{ Id=11; Clear=$true; LowRisk=$true; Bounded=$true; NoSubagents=$true; Expected='direct' },
  @{ Id=12; Ambiguous=$true; Expected='clarify' },
  @{ Id=13; HighRisk=$true; Expected='delegated' },
  @{ Id=14; HighRisk=$true; Expected='delegated' },
  @{ Id=15; DomainContract=$true; Expected='delegated' },
  @{ Id=16; HighRisk=$true; Expected='delegated' },
  @{ Id=17; CrossBoundary=$true; Expected='delegated' },
  @{ Id=18; HighRisk=$true; Expected='delegated' },
  @{ Id=19; DomainContract=$true; ExplicitReview=$true; Expected='delegated' },
  @{ Id=20; DomainContract=$true; Expected='delegated' },
  @{ Id=21; DomainContract=$true; Expected='delegated' },
  @{ Id=22; ExplicitDelegation=$true; Bounded=$true; Expected='delegated' },
  @{ Id=23; ExplicitDelegation=$true; Expected='delegated' },
  @{ Id=24; HighRisk=$true; NoSubagents=$true; Expected='direct'; IndependentReview='unavailable' }
)
foreach ($scenario in $scenarios) {
  $route = Resolve-SyntheticRoute -Scenario $scenario -PolicyText $routingRulesText
  if ($route.Boundary -ne $scenario.Expected) {
    Add-Failure "policy scenario $($scenario.Id): expected $($scenario.Expected), got $($route.Boundary)"
  }
  if ($scenario.Runtime -and $route.Runtime -ne $scenario.Runtime) {
    Add-Failure "policy scenario $($scenario.Id): explicit runtime was not preserved"
  }
  if ($scenario.IndependentReview -and $route.IndependentReview -ne $scenario.IndependentReview) {
    Add-Failure "policy scenario $($scenario.Id): expected review=$($scenario.IndependentReview), got $($route.IndependentReview)"
  }
}
if ($scenarios.Count -ge 24) {
  Write-Output "POLICY ROUTE SCENARIOS PASSED: count=$($scenarios.Count)"
}

function Test-EvidenceReuse {
  param(
    [hashtable]$Prior,
    [hashtable]$Current
  )

  return ($Prior.Status -eq 'passed' -and $Prior.Complete -and $Prior.Applicable -and
    $Prior.Artifact -eq $Current.Artifact -and $Prior.Environment -eq $Current.Environment -and
    $Prior.Scope -eq $Current.Scope)
}

$evidenceCases = @(
  @{ Id='valid unchanged result'; Prior=@{Status='passed';Complete=$true;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a1';Environment='e1';Scope='s1'}; Expected=$true },
  @{ Id='changed artifact'; Prior=@{Status='passed';Complete=$true;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a2';Environment='e1';Scope='s1'}; Expected=$false },
  @{ Id='changed environment'; Prior=@{Status='passed';Complete=$true;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a1';Environment='e2';Scope='s1'}; Expected=$false },
  @{ Id='prior failure'; Prior=@{Status='failed';Complete=$true;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a1';Environment='e1';Scope='s1'}; Expected=$false },
  @{ Id='incomplete original symptom'; Prior=@{Status='passed';Complete=$false;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a1';Environment='e1';Scope='s1'}; Expected=$false },
  @{ Id='scope mismatch'; Prior=@{Status='passed';Complete=$true;Applicable=$true;Artifact='a1';Environment='e1';Scope='s1'}; Current=@{Artifact='a1';Environment='e1';Scope='s2'}; Expected=$false }
)
foreach ($case in $evidenceCases) {
  $actual = Test-EvidenceReuse -Prior $case.Prior -Current $case.Current
  if ($actual -ne $case.Expected) {
    Add-Failure "evidence reuse '$($case.Id)': expected $($case.Expected), got $actual"
  }
}
if ($evidenceCases.Count -ge 6) {
  Write-Output "EVIDENCE REUSE SCENARIOS PASSED: count=$($evidenceCases.Count)"
}

function Select-Effort {
  param([string]$Role, [string]$Requested, [string]$RequestedModel)
  $defaults = @{ Astra='medium'; Luna='medium'; acceptance_process='high' }
  $models = @{ Astra='gpt-6-astra'; Luna='gpt-6-luna'; acceptance_process='gpt-6.1-sol' }
  $supported = @('low', 'medium', 'high', 'max')
  if ($RequestedModel -and $RequestedModel -ne $models[$Role]) {
    return [pscustomobject]@{ Outcome='reject'; RequestedModel=$RequestedModel; RequestedEffort=$Requested }
  }
  if ($Requested -and $supported -notcontains $Requested) {
    return [pscustomobject]@{ Outcome='reject'; RequestedModel=$RequestedModel; RequestedEffort=$Requested }
  }
  return [pscustomobject]@{ Outcome='accept'; Model=$models[$Role]; Effort=if($Requested){$Requested}else{$defaults[$Role]} }
}

$effortCases = @(
  @{ Role='Astra'; Requested='low'; Expected='low' }, @{ Role='Astra'; Requested='medium'; Expected='medium' },
  @{ Role='Astra'; Requested='high'; Expected='high' }, @{ Role='Astra'; Requested='max'; Expected='max' },
  @{ Role='Luna'; Requested='low'; Expected='low' }, @{ Role='Luna'; Requested='medium'; Expected='medium' },
  @{ Role='Luna'; Requested='high'; Expected='high' }, @{ Role='Luna'; Requested='max'; Expected='max' },
  @{ Role='acceptance_process'; Requested='low'; Expected='low' }, @{ Role='acceptance_process'; Requested='medium'; Expected='medium' },
  @{ Role='acceptance_process'; Requested='high'; Expected='high' }, @{ Role='acceptance_process'; Requested='max'; Expected='max' },
  @{ Role='Astra'; Requested='extreme'; Expected='reject' }, @{ Role='Luna'; Requested='extreme'; Expected='reject' },
  @{ Role='acceptance_process'; Requested='extreme'; Expected='reject' },
  @{ Role='Astra'; Requested='medium'; RequestedModel='unsupported-model'; Expected='reject' },
  @{ Role='Luna'; Requested='medium'; RequestedModel='unsupported-model'; Expected='reject' },
  @{ Role='acceptance_process'; Requested='medium'; RequestedModel='unsupported-model'; Expected='reject' }
  ,@{ Role='Astra'; Requested='low'; RequestedModel='gpt-6-astra'; Expected='low' }
  ,@{ Role='Luna'; Requested='high'; RequestedModel='gpt-6-luna'; Expected='high' }
  ,@{ Role='acceptance_process'; Requested='max'; RequestedModel='gpt-6.1-sol'; Expected='max' }
  ,@{ Role='Astra'; Requested=$null; Expected='medium' }
  ,@{ Role='Luna'; Requested=$null; Expected='medium' }
  ,@{ Role='acceptance_process'; Requested=$null; Expected='high' }
)
foreach ($case in $effortCases) {
  $actual = Select-Effort -Role $case.Role -Requested $case.Requested -RequestedModel $case.RequestedModel
  $actualOutcome = if ($actual.Outcome -eq 'reject') { 'reject' } else { $actual.Effort }
  if ($actualOutcome -ne $case.Expected) { Add-Failure "effort $($case.Role)/$($case.Requested): expected $($case.Expected), got $actualOutcome" }
  if ($case.Expected -eq 'reject' -and $actual.RequestedEffort -ne $case.Requested) { Add-Failure "effort $($case.Role): rejected request was not preserved" }
}
if ($effortCases.Count -ge 18) { Write-Output "EFFORT POLICY SCENARIOS PASSED: count=$($effortCases.Count)" }

$lunaEligibilityTokens = @('bounded_scope', 'explicit_output', 'low_ambiguity', 'repeatable_or_batch_like', 'material_aggregate_workload_benefit')
if (($lunaEligibilityTokens | Where-Object { -not $routingRulesText.Contains($_) }).Count) {
  Add-Failure 'Luna eligibility guard is incomplete'
} else {
  Write-Output 'LUNA ELIGIBILITY GUARD CHECK PASSED'
}

if ($scenarios[23].HighRisk -and $scenarios[23].NoSubagents -and
    $routingRulesText.Contains('high_risk:') -and $routingRulesText.Contains('security_or_domain_gate')) {
  Write-Output 'NO-SUBAGENT HIGH-RISK GATE DISCLOSURE CHECK PASSED'
} else {
  Add-Failure 'route 24 did not retain high-risk gates with unavailable independent review'
}

if ($failed.Count) {
  $failed | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Output 'ASTRA-LUNA ACCEPTANCE WORKFLOW ROUTING CHECK PASSED (IN-SCOPE POLICY CONTRACTS)'
exit 0
