SELECT 
    CASE 
        WHEN p.income < 30000 THEN '1. $0-$30k'
        WHEN p.income BETWEEN 30000 AND 59999 THEN '2. $30k-$60k'
        WHEN p.income BETWEEN 60000 AND 89999 THEN '3. $60k-$90k'
        WHEN p.income BETWEEN 90000 AND 119999 THEN '4. $90k-$120k'
        ELSE '5. Above $120k'
    END AS income_bracket,
    CASE 
        WHEN e.encounterclass IN ('ambulatory', 'emergency', 'outpatient') THEN e.encounterclass
        ELSE 'other'
    END AS encounterclass,
    COUNT(DISTINCT p.id) AS cancer_patients,
    COUNT(e.id) AS total_encounters,
    ROUND(1.0 * COUNT(e.id) / NULLIF(COUNT(DISTINCT p.id), 0), 1) AS avg_encounters_per_patient,
    ROUND(AVG(e.total_claim_cost)::numeric, 2) AS avg_encounter_cost
FROM patients p
JOIN conditions c ON p.id = c.patient
JOIN encounters e ON p.id = e.patient
WHERE c.description ILIKE '%cancer%' 
   OR c.description ILIKE '%malignant%'
   OR c.description ILIKE '%carcinoma%'
GROUP BY income_bracket, encounterclass
ORDER BY income_bracket, total_encounters DESC;