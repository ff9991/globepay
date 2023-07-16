SELECT
  created_at,
  COUNT(*) AS total_transactions,
  SUM(CASE WHEN status = 'ACCEPTED' THEN 1 ELSE 0 END) AS accepted_transactions,
  SUM(CASE WHEN status = 'ACCEPTED' THEN 1 ELSE 0 END) / COUNT(*) AS acceptance_rate
FROM
  payments
GROUP BY
  created_at
ORDER BY
  created_at