---

# Governance

## Catalog, schema, and volume structure

The pipeline uses a single Unity Catalog catalog (`tep_lakehouse`) with three schemas corresponding to the medallion layers: `bronze`, `silver`, and `gold`. Raw source files land in a managed Volume at `/Volumes/tep_lakehouse/bronze/raw_files/`, which decouples file ingestion from table management and avoids legacy DBFS paths entirely. Auto Loader reads from this volume and writes to `tep_lakehouse.bronze.raw_tep`; subsequent layers are derived tables within their respective schemas.

Keeping all three layers within a single catalog makes cross-layer queries cheap and ensures lineage is captured without gaps. In a multi-team or multi-environment production workspace, separate catalogs per environment (dev / staging / prod) would be the appropriate evolution.

## Grants by persona

Three personas cover the intended access model:

- **analyst** — `SELECT` on `tep_lakehouse.gold.*` only. Analysts consume the curated Gold layer and have no visibility into raw or intermediate data.
- **engineer** — `USE CATALOG`, `USE SCHEMA` on all schemas; `SELECT` and `MODIFY` on `bronze` and `silver`. Engineers can read and write the ingestion and transformation layers for pipeline development and debugging.
- **admin** — `ALL PRIVILEGES` on `tep_lakehouse`. Manages catalog structure and grants privileges to other roles.

Grants follow least-privilege: the Gold schema is the only layer exposed to consumers, and no persona below admin can modify grants or create new schemas.

## Lineage in Catalog Explorer

Unity Catalog captures lineage automatically at table and column level whenever data is written via Spark DataFrames or SQL within the catalog. Navigating to any Gold table in Catalog Explorer and selecting the **Lineage** tab shows the full upstream chain: Gold ← Silver ← Bronze, along with the specific notebook or Job run that produced each write.
![lineage graph](governance/lineage%20graph.jpg)

Column-level lineage propagates cleanly through simple select and rename transformations in the Silver layer. Gold aggregations appear as table-level lineage only, which is expected behaviour when Unity Catalog cannot unambiguously trace a column through a grouping or aggregation expression.

## What would be added in a production workspace

**Row and column-level security (ABAC).** Broad schema-level grants would be replaced with Delta row filters and column masks, restricting sensitive process variables or batch identifiers to specific groups without duplicating tables or building separate views for each consumer.

**Audit log streaming to system tables.** Enabling `system.access.audit` captures every read, write, and permission change with user identity, timestamp, and query text. In a regulated manufacturing context this is not optional — it provides a tamper-resistant trail for health authority inspections and internal data governance reviews. Streaming these to an external SIEM or a BI-accessible Delta table makes them queryable without granting direct system table access to auditors.

**Automated tag propagation.** Tags applied at the catalog or schema level (e.g. `sensitivity:internal`, `domain:manufacturing`, `data_tier:gold`) would propagate to tables and columns via a governance job or enforced tagging policy in the pipeline code itself. This feeds downstream data cataloguing tools, enables policy automation, and removes the maintenance burden of tagging individual assets manually as the catalog grows.
