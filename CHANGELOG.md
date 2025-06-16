# 161 - Rework Workflows

- trigger - test patch and minor label - should fail (only one label can be present)
- trigger - workflow failed - expected only one label - removed patch - testing minor
- trigger - test minor

rc-workflow
- trigger - test major label - expected v1.0.0-RC+184 from v0.7.0+183

production-workflow
- trigger - test RC flag being removed
- git fetch --prune --prune-tags <- Removes local tags