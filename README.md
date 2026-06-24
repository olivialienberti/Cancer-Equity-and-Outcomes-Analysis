# Cancer Treatment Equity Analysis
### SQL & Power BI Portfolio Project

## Overview
Analysis of 70,000 rows of synthetic electronic health record data (Synthea, 12,000 patients) to investigate disparities in cancer diagnosis, treatment access, and outcomes across income brackets. 
Findings translated into evidence-based recommendations for improving cancer care equity.

## Research Questions
1. Do cancer diagnosis rates differ across income brackets?
2. Do lower-income patients face greater financial barriers to treatment?
3. How do these financial barriers to treatment manifest themselves in patient treatment?
4. Do survival outcomes differ by income bracket?

## Key Findings
- Patients in the lowest income bracket (below $30k) demonstrated the 
  highest cancer diagnosis rates of any income group
- Out-of-pocket costs represented a disproportionately high percentage of income for lower-income cancer patients, creating a significant barrier to timely healthcare engagement
  - Lower-income patients showed greater average days between diagnosis and first clinical encounter, indicating delayed treatment initiation
  - Lower-income patients also demonstrated a comparitively large proportion of emergency and ambulatory-based   encounters, potentially suggesting that the increased costs of treatment may prolong medical action until the last minute
- Survival time post-diagnosis did not follow the expected pattern, potentially reflecting survivorship bias or cancer type distribution differences across income groups

## Recommendations
1. Targeted cancer screening programs in low-income postcodes
2. Government-subsidised co-payment schemes for cancer-related hospital visits

## Further Research
- Cancer type distribution across income brackets
- Analysis of undiagnosed cancer statistics
- Stage at diagnosis by income group

## Technical Stack
| Tool | Purpose |
|---|---|
| Synthea | Synthetic EHR data generation (12,000 patients) |
| PostgreSQL | Data storage and SQL analysis |
| Power BI | Dashboard and visualisation |
| SQL | Data extraction, transformation, aggregation |

## Data

Raw data files are not included in this repository due to file size 
constraints and data governance best practices.

### Reproducing the Dataset
Patient data was generated using [Synthea](https://github.com/synthetichealth/synthea), 
an open-source synthetic patient generator. To reproduce the dataset:

1. Clone the Synthea repository
2. Run the following command to generate 12,000 patients:
```bash
./gradlew run --args="-p 12000 --exporter.csv.export=true --exporter.fhir.export=false"
```
3. Load the generated CSVs into PostgreSQL using `sql/01_schema.sql` 
   and `sql/02_data_import.sql`

### Data Dictionary
See `data/synthea_data_dictionary.md` for a full description of 
all tables and columns used in this analysis.
## SQL Query Structure
1. `cancerrate_income.sql`
2. `diagnosisage_income.sql`
3. `careplancoverage_income.sql`
4. `mortality_income.sql`
5. `timetocare_income.sql`
6. `financialburden_income.sql`
7. `encounterclass_income.sql`
   
## Limitations
- Synthea data is synthetic and may not reflect real-world clinical distributions
- Income brackets and healthcare coverage figures reflect US dollar thresholds and government claims programs from Synthea's US-based population model, and should not be directly extrapolated to the Australian healthcare context (e.g. Medicare, PBS)
- Undiagnosed patients are not captured in the dataset, which may introduce survivorship bias
