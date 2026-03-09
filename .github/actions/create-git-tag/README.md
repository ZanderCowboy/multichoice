# Create Git Tag Action

This action creates Git tags based on version numbers with configurable format validation and tag creation strategies. It's designed to handle the different versioning requirements across develop, staging, and production workflows.

## Features

- **Flexible version format validation**: Supports standard versions (x.y.z+build), RC versions (x.y.z-RC+build), or both
- **Configurable tag strategies**: Create tags with full version (including build number) or version-only (excluding build number)
- **Comprehensive validation**: Validates version format, checks for existing tags, and provides clear error messages
- **Reusable**: Can be used across different workflows with different requirements

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `version_number` | The version number to create a tag for | Yes | - |
| `tag_strategy` | Strategy for creating the tag: `full` (include build number) or `version-only` (exclude build number) | Yes | `full` |
| `allowed_formats` | Allowed version formats: `standard` (x.y.z+build), `rc` (x.y.z-RC+build), or `both` | Yes | `both` |

## Outputs

| Output | Description |
|--------|-------------|
| `tag_version` | The version used for the tag (without 'v' prefix) |
| `full_version` | The full version number including build number |

## Usage Examples

### Develop Workflow

Creates tags with full version including build number, accepting both standard and RC formats:

```yaml
- name: Create New Tag
  uses: ./.github/actions/create-git-tag
  with:
    version_number: ${{ needs.preBuild.outputs.version_number }}
    tag_strategy: "full"
    allowed_formats: "both"
```

### Staging Workflow

Creates tags with full version including build number, only accepting RC formats:

```yaml
- name: Create New Tag
  uses: ./.github/actions/create-git-tag
  with:
    version_number: ${{ needs.preBuild.outputs.version_number }}
    tag_strategy: "full"
    allowed_formats: "rc"
```

### Production Workflow

Creates tags with version-only (excluding build number), only accepting standard formats:

```yaml
- name: Create New Tag
  id: create_tag
  uses: ./.github/actions/create-git-tag
  with:
    version_number: ${{ needs.preBuild.outputs.version_number }}
    tag_strategy: "version-only"
    allowed_formats: "standard"
```

## Version Format Examples

### Standard Format (x.y.z+build)

- `1.0.0+123`
- `2.1.5+456`

### RC Format (x.y.z-RC+build)

- `1.0.0-RC+123`
- `2.1.5-RC+456`

## Tag Strategy Examples

### Full Strategy

- Input: `1.0.0+123`
- Tag: `v1.0.0+123`

### Version-Only Strategy

- Input: `1.0.0+123`
- Tag: `v1.0.0`

## Error Handling

The action provides clear error messages for common issues:

- Empty version number
- Invalid version format
- Invalid tag strategy
- Invalid allowed formats
- Tag already exists
- Invalid tag version format (for version-only strategy)

## Migration from Inline Scripts

This action replaces the inline "Create New Tag" scripts in the workflows:

- **Before**: 20+ lines of bash script in each workflow
- **After**: 4-5 lines of action configuration

This reduces code duplication and makes the workflows more maintainable.
