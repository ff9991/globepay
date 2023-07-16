SELECT
  p.*
FROM
  payments p
WHERE
  chargeback = 'FALSE'   --There is always a 'TRUE' or 'FALSE' value in the source for this data.
                        --We can assume that a NULL value corresponds to a missing value for a payment in our source data.