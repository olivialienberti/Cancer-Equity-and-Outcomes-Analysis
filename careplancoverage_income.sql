SELECT 
    CASE 
        WHEN p.income < 30000 THEN '1. $0-$30k'
        WHEN p.income BETWEEN 30000 AND 59999 THEN '2. $30k-$60k'
        WHEN p.income BETWEEN 60000 AND 89999 THEN '3. $60k-$90k'
        WHEN p.income BETWEEN 90000 AND 119999 THEN '4. $90k-$120k'
        ELSE '5. Above $120k'
    END AS income_bracket,
    COUNT(DISTINCT p.id) AS cancer_patients,
    COUNT(DISTINCT cp.patient) AS patients_with_careplan,
    ROUND(100.0 * COUNT(DISTINCT cp.patient) 
          / NULLIF(COUNT(DISTINCT p.id), 0), 1) AS careplan_coverage_pct,
    COUNT(DISTINCT CASE WHEN cp.stop IS NULL THEN cp.patient END) AS active_careplans,
    COUNT(DISTINCT CASE WHEN cp.stop IS NOT NULL THEN cp.patient END) AS completed_careplans
FROM patients p
JOIN conditions c ON p.id = c.patient
LEFT JOIN careplans cp ON p.id = cp.patient
WHERE c.description ILIKE '%cancer%' 
   OR c.description ILIKE '%malignant%'
   OR c.description ILIKE '%carcinoma%'
GROUP BY income_bracket
ORDER BY income_bracket;
