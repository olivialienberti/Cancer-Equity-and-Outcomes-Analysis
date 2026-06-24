SELECT 
    CASE 
        WHEN p.income < 30000 THEN '1. $0-$30k'
        WHEN p.income BETWEEN 30000 AND 59999 THEN '2. $30k-$60k'
        WHEN p.income BETWEEN 60000 AND 89999 THEN '3. $60k-$90k'
        WHEN p.income BETWEEN 90000 AND 119999 THEN '4. $90k-$120k'
        ELSE '5. Above $120k'
    END AS income_bracket,
    COUNT(DISTINCT p.id) AS cancer_patients,
    ROUND(AVG(EXTRACT(DAY FROM (first_encounter_after.start - c.start)))::numeric, 0) 
          AS avg_days_to_first_encounter,
    ROUND(MIN(EXTRACT(DAY FROM (first_encounter_after.start - c.start)))::numeric, 0) AS min_days,
    ROUND(MAX(EXTRACT(DAY FROM (first_encounter_after.start - c.start)))::numeric, 0) AS max_days
FROM patients p
JOIN conditions c ON p.id = c.patient
JOIN (
    SELECT e.patient, MIN(e.start) AS start, c2.start AS diagnosis_date
    FROM encounters e
    JOIN conditions c2 ON e.patient = c2.patient
    WHERE (c2.description ILIKE '%cancer%' 
       OR c2.description ILIKE '%malignant%'
       OR c2.description ILIKE '%carcinoma%')
    AND e.start >= c2.start
    GROUP BY e.patient, c2.start
) first_encounter_after ON p.id = first_encounter_after.patient
WHERE c.description ILIKE '%cancer%' 
   OR c.description ILIKE '%malignant%'
   OR c.description ILIKE '%carcinoma%'
GROUP BY income_bracket
ORDER BY income_bracket;