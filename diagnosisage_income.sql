SELECT 
    CASE 
        WHEN p.income < 30000 THEN '1. $0-$30k'
        WHEN p.income BETWEEN 30000 AND 59999 THEN '2. $30k-$60k'
        WHEN p.income BETWEEN 60000 AND 89999 THEN '3. $60k-$90k'
        WHEN p.income BETWEEN 90000 AND 119999 THEN '4. $90k-$120k'
        ELSE '5. Above $120k'
    END AS income_bracket,
    COUNT(DISTINCT p.id) AS cancer_patients,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(c.start, p.birthdate)))::numeric, 1) AS avg_age_at_diagnosis,
    ROUND(MIN(EXTRACT(YEAR FROM AGE(c.start, p.birthdate)))::numeric, 1) AS youngest_diagnosis,
    ROUND(MAX(EXTRACT(YEAR FROM AGE(c.start, p.birthdate)))::numeric, 1) AS oldest_diagnosis
FROM patients p
JOIN conditions c ON p.id = c.patient
WHERE c.description ILIKE '%cancer%' 
   OR c.description ILIKE '%malignant%'
   OR c.description ILIKE '%carcinoma%'
GROUP BY income_bracket
ORDER BY income_bracket;