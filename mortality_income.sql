SELECT 
    CASE 
        WHEN p.income < 30000 THEN '1. $0-$30k'
        WHEN p.income BETWEEN 30000 AND 59999 THEN '2. $30k-$60k'
        WHEN p.income BETWEEN 60000 AND 89999 THEN '3. $60k-$90k'
        WHEN p.income BETWEEN 90000 AND 119999 THEN '4. $90k-$120k'
        ELSE '5. Above $120k'
    END AS income_bracket,
    COUNT(DISTINCT p.id) AS cancer_patients,
    COUNT(DISTINCT CASE WHEN p.deathdate IS NOT NULL THEN p.id END) AS deceased,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN p.deathdate IS NOT NULL THEN p.id END) 
          / NULLIF(COUNT(DISTINCT p.id), 0), 1) AS mortality_rate_pct,
    ROUND(AVG(CASE WHEN p.deathdate IS NOT NULL 
              THEN EXTRACT(YEAR FROM AGE(p.deathdate, c.start)) END)::numeric, 1) 
              AS avg_years_survived_after_diagnosis
FROM patients p
JOIN conditions c ON p.id = c.patient
WHERE c.description ILIKE '%cancer%' 
   OR c.description ILIKE '%malignant%'
   OR c.description ILIKE '%carcinoma%'
GROUP BY income_bracket
ORDER BY income_bracket;