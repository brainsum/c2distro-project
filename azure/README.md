# Azure Pipelines

- Create a repository on dev.azure.com
- Go to `Pipelines / Library` and add a new variable group called `Common`
    - Note, if you don't like the name, you can use anything else, but you need to update any `group: common` references in the pipeline files
- Go to `https://dev.azure.com/<org>/<repo>/_settings/settings / pipelines / settings` and enable `Publish metadata from pipelines (preview)`    
- Add your pipelines to azure at `New pipeline \ <connect your repo and select it> \ Existing Azure Pipelines YAML file`
    - Note, you need to rename each pipeline one by one to the same as `source` in the pipelines files
        - `PHP Image (Prod)`
        - `Builder Image (Prod)`
        - `App Image (Prod)`
        - `PHP Image`
        - `Builder Image`
        - `App Image`
    