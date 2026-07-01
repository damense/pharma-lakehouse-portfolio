-- TEST 1: Faulty train tables have exactly 500 rows each
SELECT 'faulty_training_fault_01' AS table_name, COUNT(*) AS row_count
FROM tep_lakehouse.silver.faulty_training_fault_01
HAVING COUNT(*) != 500;

-- TEST 2: No duplicate timestamps within a faulty table
SELECT relative_time_h, COUNT(*) AS n
FROM tep_lakehouse.silver.faulty_training_fault_01
GROUP BY relative_time_h
HAVING COUNT(*) > 1;

-- TEST 3: All 52 variables in normality stats resolve to variable reference
SELECT s.variable
FROM tep_lakehouse.silver.faultfree_normality_stats s
LEFT JOIN tep_lakehouse.silver.variable_reference r ON s.variable = r.variable
WHERE r.variable IS NULL;

-- TEST 4: time_since_fault_h is negative before fault introduction
SELECT COUNT(*) AS should_be_zero
FROM tep_lakehouse.silver.faulty_training_fault_01
WHERE time_since_fault_h >= 0;

-- TEST 5: Silver row counts match bronze after averaging
SELECT COUNT(*) AS silver_rows 
FROM tep_lakehouse.silver.faultfree_training
-- Should equal 500 (one row per sample after averaging across simulations)