SELECT
  country,
  SUM(CASE WHEN status = 'DECLINED' THEN amount ELSE 0 END) AS declined_amount
FROM
  payments
GROUP BY
  country
HAVING
  SUM(CASE WHEN status = 'DECLINED' THEN amount ELSE 0 END) > 25000000